local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if ok_lspconfig and ok_cmp_nvim_lsp then
  
  local capabilities = cmp_nvim_lsp.default_capabilities()
  local on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local map = vim.keymap.set

    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', 'gi', vim.lsp.buf.implementation, opts)
    map('n', 'rn', vim.lsp.buf.rename, opts)
    map('n', 'ca', vim.lsp.buf.code_action, opts)
    map('n', '[d', vim.diagnostic.goto_prev, opts)
    map('n', ']d', vim.diagnostic.goto_next, opts)
  end

  lspconfig.tsserver.setup {
    capabilities = capabilities,
    on_attach = on_attach
  }

  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      },
    },
  }
end

