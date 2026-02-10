local ok_cat, catppuccin = pcall(require, "catppuccin")
if ok_cat then
  catppuccin.setup({
    flavour = "mocha",  -- roxo escuro
    transparent_background = false,
    term_colors = true,
    styles = {
      comments = { "italic" },
      functions = { "bold" },
      keywords = { "italic" },
    },
    integrations = {
      lualine = true,
      telescope = true,
      neogit = true,
      treesitter = true,
    },
  })
  vim.cmd("colorscheme catppuccin")
end
