-- =====================================
--  LSP: mason + configs nativas (vim.lsp.config)
-- =====================================

-- Mason: instala servidores e coloca mason/bin no PATH
local ok_mason, mason = pcall(require, "mason")
if ok_mason then
  mason.setup()
end

local ok_installer, installer = pcall(require, "mason-tool-installer")
if ok_installer then
  installer.setup({
    ensure_installed = {
      "lua-language-server",
      "jdtls",
      "java-debug-adapter",
      "java-test",
    },
    run_on_start = true,
  })
end

-- Capabilities do nvim-cmp para todos os servidores
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_nvim_lsp then
  vim.lsp.config("*", { capabilities = cmp_nvim_lsp.default_capabilities() })
end

-- Atalhos de LSP para QUALQUER servidor (inclusive jdtls)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
  callback = function(args)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "LSP: definição")
    map("n", "gD", vim.lsp.buf.declaration, "LSP: declaração")
    map("n", "gi", vim.lsp.buf.implementation, "LSP: implementação")
    map("n", "gr", vim.lsp.buf.references, "LSP: referências")
    map("n", "K", vim.lsp.buf.hover, "LSP: hover")
    map("n", "rn", vim.lsp.buf.rename, "LSP: renomear")
    map({ "n", "v" }, "ca", vim.lsp.buf.code_action, "LSP: code action")
    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Diagnóstico anterior")
    map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Próximo diagnóstico")
    map("n", "gl", vim.diagnostic.open_float, "Diagnóstico: detalhes")
    map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "LSP: formatar")
  end,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
    },
  },
})

-- jdtls NÃO entra aqui: é iniciado pelo nvim-jdtls em ftplugin/java.lua
vim.lsp.enable({ "ts_ls", "lua_ls", "rust_analyzer" })
