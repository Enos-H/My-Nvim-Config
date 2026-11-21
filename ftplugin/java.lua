-- =====================================
--  Java: eclipse.jdt.ls via nvim-jdtls
--  Roda a cada buffer Java; start_or_attach reaproveita o cliente
--  existente para a mesma raiz, então só há UM jdtls por projeto.
-- =====================================

-- Classes descompiladas (jdt://) são anexadas pelo próprio nvim-jdtls
if vim.api.nvim_buf_get_name(0):match("^jdt://") then return end

local ok_jdtls, jdtls = pcall(require, "jdtls")
if not ok_jdtls then return end

local home = vim.env.HOME
local mason = vim.fn.stdpath("data") .. "/mason/packages"
local jdtls_dir = mason .. "/jdtls"

local launcher = vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1]
if not launcher then
  vim.notify("jdtls não instalado. Rode :MasonInstall jdtls", vim.log.levels.WARN)
  return
end

-- -------------------------------------
--  Raiz do projeto (estável)
--  1º wrapper/settings de build ou .git (raiz do repositório),
--  senão o pom.xml/build.gradle MAIS EXTERNO (multi-módulo).
-- -------------------------------------
local function find_root()
  local root = vim.fs.root(0, { { "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts" }, ".git" })
  if root then return root end

  local build_files = vim.fs.find({ "pom.xml", "build.gradle", "build.gradle.kts" }, {
    upward = true,
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    limit = math.huge,
  })
  if #build_files > 0 then
    return vim.fs.dirname(build_files[#build_files]) -- o último é o mais externo
  end
end

local root_dir = find_root()
if not root_dir then return end -- arquivo .java solto: sem LSP

local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. root_dir:gsub("/", "-")

-- -------------------------------------
--  JDKs
-- -------------------------------------
local jdk21 = home .. "/.jdks/jdk-21.0.10+7"   -- roda o próprio jdtls (exige 21+)
local runtimes = {
  { name = "JavaSE-17", path = home .. "/.jdks/jdk17" },
  { name = "JavaSE-21", path = jdk21 },
  { name = "JavaSE-25", path = "/usr/lib/jvm/java-25-openjdk-amd64", default = true },
}
local java_bin = vim.uv.fs_stat(jdk21 .. "/bin/java") and (jdk21 .. "/bin/java") or "java"

-- -------------------------------------
--  Bundles: debug (java-debug-adapter) e testes (java-test)
-- -------------------------------------
local bundles = vim.fn.glob(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
for _, jar in ipairs(vim.fn.glob(mason .. "/java-test/extension/server/*.jar", true, true)) do
  local name = vim.fs.basename(jar)
  if name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar" and name ~= "jacocoagent.jar" then
    table.insert(bundles, jar)
  end
end

local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

local config = {
  name = "jdtls",
  cmd = {
    java_bin,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.level=WARN",
    "-javaagent:" .. jdtls_dir .. "/lombok.jar",
    "-Xmx2G",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher,
    "-configuration", jdtls_dir .. "/config_linux",
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  capabilities = ok_cmp and cmp_nvim_lsp.default_capabilities() or nil,
  settings = {
    java = {
      configuration = {
        runtimes = runtimes,
        updateBuildConfiguration = "automatic",
      },
      maven = { downloadSources = true },
      eclipse = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      inlayHints = { parameterNames = { enabled = "literals" } },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.springframework.test.util.ReflectionTestUtils.*",
        },
      },
      sources = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
    },
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
  on_attach = function(_, bufnr)
    if #bundles > 0 then
      jdtls.setup_dap({ hotcodereplace = "auto" })
    end

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end
    map("n", "<leader>jo", jdtls.organize_imports, "Java: organizar imports")
    map({ "n", "v" }, "<leader>jv", function() jdtls.extract_variable({ visual = vim.fn.mode() ~= "n" }) end, "Java: extrair variável")
    map({ "n", "v" }, "<leader>jc", function() jdtls.extract_constant({ visual = vim.fn.mode() ~= "n" }) end, "Java: extrair constante")
    map("v", "<leader>jm", function() jdtls.extract_method({ visual = true }) end, "Java: extrair método")
    map("n", "<leader>jt", function() require("jdtls.dap").test_nearest_method() end, "Java: testar método")
    map("n", "<leader>jT", function() require("jdtls.dap").test_class() end, "Java: testar classe")
    map("n", "<leader>jd", function() require("dap").continue() end, "Java: debug (continuar)")
    map("n", "<leader>jb", function() require("dap").toggle_breakpoint() end, "Java: breakpoint")
  end,
}

jdtls.start_or_attach(config)
