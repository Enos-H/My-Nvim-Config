local ok_telescope, telescope = pcall(require, 'telescope')
if ok_telescope then
  telescope.setup {
    defaults = {
      path_display = {"absolute"},
      layout_strategy = "center",
      layout_config = {
        width = 0.8,
        height = 0.6,
        prompt_position = "top",
        preview_cutoff = 40,
      },
      sorting_strategy = "ascending",
      winblend = 20, -- transparência maior
      borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    },
    extensions = {
      file_browser = {
        theme = "ivy",       -- layout compacto na parte inferior
        hijack_netrw = true, -- substitui o netrw padrão
        hidden = true,       -- mostrar arquivos ocultos
        grouped = true,      -- agrupa diretórios antes dos arquivos
      }
    }
  }
  -- Carrega a extensão
  telescope.load_extension("file_browser")

  local map = vim.keymap.set

  map('n', '<leader>fe', "<cmd>Telescope file_browser<cr>", { desc = "Navegador de arquivos (Telescope)" })
  map('n', '<leader>ff', "<cmd>Telescope find_files<cr>", { desc = "Buscar arquivos" })
  map('n', '<leader>fg', "<cmd>Telescope live_grep<cr>",  { desc = "Buscar texto" })
  map('n', '<leader>fb', "<cmd>Telescope buffers<cr>",    { desc = "Buscar buffers" })
  map('n', '<leader>fh', "<cmd>Telescope help_tags<cr>",  { desc = "Ajuda" })
  map('n', '<leader>fo', "<cmd>Telescope oldfiles<cr>",   { desc = "Arquivos recentes" })
  map('n', '<leader>fc', "<cmd>Telescope commands<cr>",   { desc = "Comandos" })
  map('n', '<leader>fr', "<cmd>Telescope resume<cr>",     { desc = "Reabrir última busca" })
end


