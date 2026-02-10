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
end


