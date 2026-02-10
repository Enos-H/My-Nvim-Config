local neogit = require("neogit")

neogit.setup({
  integrations = { diffview = true },
  signs = {
    section = { "", "" },
    item = { "", "" },
  }, 
})

vim.keymap.set('n', '<leader>b', ':Neogit<CR>', { noremap = true, silent = true })

