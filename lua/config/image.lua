-- ==========================================
-- Image.nvim - Renderiza imagens no buffer
-- (png/svg/mermaid via kitty graphics protocol)
-- ==========================================

local ok_image, image = pcall(require, 'image')

if ok_image then
  image.setup {
    -- Kitty é capaz de exibir SVG nativamente
    backend = "kitty",
    processor = "magick_cli",

    -- Renderiza imagens em markdown
    markdown = {
      enabled = true,
      only_render_image_at_cursor = false,
      clear_in_insert_mode = false,

      mermaid = {
        cli = "mmdc",
        args = { "-t", "dark", "-p", "/home/enosh/.local/share/mermaid-cli/puppeteer-config.json" },
        extras = { "-b", "transparent" },
        extension = "svg",
      },
    },
  }

  -- Maps
  local map = vim.keymap.set
  map('n', '<leader>it', '<cmd>Image toggleAll<cr>', { desc = "Image: mostra/esconde imagens" })
  map('n', '<leader>ir', '<cmd>Image update<cr>',    { desc = "Image: re-renderiza mermaid/imagens" })
end