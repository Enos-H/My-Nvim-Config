
local ok_fzf, fzf = pcall(require, "fzf-lua")

if ok_fzf then
  fzf.setup({
    winopts = {
      height = 0.5,
      width = 0.8,
      row = 0.3,
      col = 0.1,
    },
    keymap = {
      fzf = {
        ["ctrl-j"] = "down",
        ["ctrl-k"] = "up",
        ["ctrl-f"] = "preview-page-down",
        ["ctrl-b"] = "preview-page-up",
      },
    },
  })
  
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  map('n', '<leader>sf', ':Files<CR>',  { desc = "Buscar arquivos (FZF)" }, opts)
  map('n', '<leader>sb', ':Buffers<CR>', { desc = "Buscar buffers (FZF)" }, opts)
  map('n', '<leader>sl', ':Lines<CR>',  { desc = "Buscar linhas em buffers (FZF)" }, opts)
  map('n', '<leader>sg', ':GFiles<CR>', { desc = "Buscar arquivos Git (FZF)" }, opts)
  map('n', '<leader>sh', ':History<CR>', { desc = "Histórico de arquivos (FZF)" }, opts)
  map('n', '<leader>sr', ':Rg<CR>',     { desc = "Buscar texto com ripgrep (FZF)" }, opts)
end


