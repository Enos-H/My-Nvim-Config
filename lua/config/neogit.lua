local ok_neogit, neogit = pcall(require, "neogit")

if ok_neogit then
  neogit.setup({
    integrations = { diffview = true },
    signs = {
      section = { "", "" },
      item = { "", "" },
    }, 
  })

  local map = vim.keymap.set

  map('n', '<leader>b', ':Neogit<CR>', { noremap = true, silent = true })

end
