-- ================================
-- Atalhos e Keymaps personalizados
-- ================================

-- Define a tecla líder como espaço
vim.g.mapleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- =====================
-- Geral
-- =====================
map('n', '<leader>w', ':w<CR>', { desc = "Salvar arquivo" })
map('n', '<leader>q', ':q<CR>', { desc = "Fechar janela" })
map('n', '<leader>e', ':Explore<CR>', { desc = "Abrir explorador" })
