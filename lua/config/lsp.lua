-- ======================================
-- Configuração de LSP (Language Servers)
-- ======================================

local lspconfig = require('lspconfig')
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Função que ativa atalhos quando o LSP conecta
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
end

-- TypeScript / JavaScript
lspconfig.tsserver.setup {
  capabilities = cmp_capabilities,
  on_attach = on_attach
}

-- Lua (para Neovim e plugins em Lua)
lspconfig.lua_ls.setup {
  capabilities = cmp_capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
    },
  },
}

-- Treesitter (highlight e indentação melhorados)
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "javascript", "typescript", "html", "css", "json", "scheme", "yuck" },
  sync_install = false,       -- instala em paralelo
  auto_install = true,        -- instala automaticamente parsers faltando
  ignore_install = {},        -- lista de parsers ignorados
  modules = {},               -- campo exigido pelo TSConfig

  highlight = { enable = true },
  indent = {
    enable = true,
    disable = { "yuck" },     -- desativa indentação só para yuck
  },
}
