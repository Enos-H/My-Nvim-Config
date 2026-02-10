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

-- =====================
-- Telescope
-- =====================
map('n', '<leader>ff', "<cmd>Telescope find_files<cr>", { desc = "Buscar arquivos" })
map('n', '<leader>fg', "<cmd>Telescope live_grep<cr>",  { desc = "Buscar texto" })
map('n', '<leader>fb', "<cmd>Telescope buffers<cr>",    { desc = "Buscar buffers" })
map('n', '<leader>fh', "<cmd>Telescope help_tags<cr>",  { desc = "Ajuda" })
map('n', '<leader>fo', "<cmd>Telescope oldfiles<cr>",   { desc = "Arquivos recentes" })
map('n', '<leader>fc', "<cmd>Telescope commands<cr>",   { desc = "Comandos" })
map('n', '<leader>fr', "<cmd>Telescope resume<cr>",     { desc = "Reabrir última busca" })

-- Telescope File Browser (carregado com segurança)
map("n", "<leader>fe", function()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify("Telescope não encontrado!", vim.log.levels.WARN)
    return
  end
  telescope.extensions.file_browser.file_browser()
end, { desc = "Navegador de arquivos (Telescope)" })

-- =====================
-- FZF
-- =====================
-- Observação: requer o plugin 'junegunn/fzf.vim' e o binário 'fzf' instalado.
map('n', '<leader>sf', ':Files<CR>',  { desc = "Buscar arquivos (FZF)" })
map('n', '<leader>sb', ':Buffers<CR>', { desc = "Buscar buffers (FZF)" })
map('n', '<leader>sl', ':Lines<CR>',  { desc = "Buscar linhas em buffers (FZF)" })
map('n', '<leader>sg', ':GFiles<CR>', { desc = "Buscar arquivos Git (FZF)" })
map('n', '<leader>sh', ':History<CR>', { desc = "Histórico de arquivos (FZF)" })
map('n', '<leader>sr', ':Rg<CR>',     { desc = "Buscar texto com ripgrep (FZF)" })

-- =====================
-- NEO-TREE
-- =====================
-- Alterna para esquerda/direita rapidamente
map('n', '<leader>h', '<C-w>h', { desc = "Alterna para janela a direita", noremap = true, silent = true })
map('n', '<leader>l', '<C-w>l', { desc = "Alterna para janela a esquerda", noremap = true, silent = true })

-- =====================
-- COPILOT.VIM 
-- =====================
vim.g.copilot_no_tab_map = true  -- Desabilita tab padrão

map('i', '<leader>ca', 'copilot#Accept()', { expr = true, silent = true, desc = "Aceitar sugestão do Copilot" })
map('i', '<leader>cn', 'copilot#Next()', { expr = true, silent = true, desc = "Próxima sugestão do Copilot" })
map('i', '<leader>cp', 'copilot#Prev()', { expr = true, silent = true, desc = "Sugestão anterior do Copilot" })
map('i', '<leader>cd', 'copilot#Dismiss()', { expr = true, silent = true, desc = "Descartar sugestão do Copilot" })

map('n', '<F1>', ':Copilot enable<CR>', { desc = "Habilitar Copilot" })
map('n', '<F2>', ':Copilot disable<CR>', { desc = "Desabilitar Copilot" })
map('n', '<F3>', ':Copilot panel<CR>', { desc = "Abrir painel do Copilot" })
map('n', '<F4>', ':Copilot status<CR>', { desc = "Copilot Status" })
