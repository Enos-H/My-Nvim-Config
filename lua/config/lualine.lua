local ok_lualine, lualine = pcall(require, 'lualine')
if ok_lualine then
  lualine.setup {
    options = {
      theme = "catppuccin",
      icons_enabled = true,
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      globalstatus = true, -- barra única
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  }
end
