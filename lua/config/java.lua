local home = os.getenv('HOME')
local jdtls = require('jdtls')

local root_markers = {'.git', 'mvnw', 'pom.xml', 'gradlew', 'build.gradle'}
local root_dir = require('jdtls.setup').find_root(root_markers)

if not root_dir then return end

local jdtls_install = home .. '/.local/share/nvim/mason/packages/jdtls'

local workspace_dir = home .. '/.cache/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':t')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundlesStartupLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. jdtls_install .. '/lombok.jar',
    '-Xmx1G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', jdtls_install .. '/config_linux',
    '-data', workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-23',
            path = home .. '/.jdks/temurin-23.0.2',
            default = true,
          }
        },
        updateBuildConfiguration = 'automatic',
        extendedClientAttributes = 'generate',
        annotationProcessing = {
          enabled = true,
          profile = "default",
          enabledByDefault = true,
        },
      },
      maven = {
        downloadSources = true
      },
      -- === LOMBOK ===
      lombokAnnotations = true,
      processors = {
        "lombok.launch.AnnotationProcessorHider$AnnotationProcessor",
        "org.projectlombok.process.pta.Processor"
      },
      -- === SPRING BOOT ===
      references = {
        includeDecompiledSources = true,
      },
      contentProvider = {
        preferred = 'fernflower'
      },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.springframework.test.util.ReflectionTestUtils.*"
        }
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },
  init_options = {
    bundles = {}
  },
  on_attach = function(client, bufnr)
    require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  end,
  on_exit = function(code)
    vim.cmd('silent !pkill -f "jdtls.*' .. root_dir .. '" || true')
    vim.notify("JDTLS terminado", vim.log.levels.INFO)
  end,
  on_init = function(client)
    vim.cmd('silent !pkill -f "jdtls.*' .. root_dir .. '" || true')
  end,
}

vim.api.nvim_create_autocmd("BufDelete", {
  buffer = vim.api.nvim_get_current_buf(),
  callback = function()
    vim.schedule(function()
      if vim.lsp.get_clients({name = "jdtls"})[1] then
        vim.lsp.stop_client(vim.lsp.get_clients({name = "jdtls"})[1].id)
      end
    end)
  end,
})

jdtls.start_or_attach(config)
