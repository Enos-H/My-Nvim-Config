require("neo-tree").setup({
  close_if_last_window = true,
  enable_git_status = false,
  enable_diagnostics = true,
  default_component_configs = {
    git_status = {
      symbols = {
        added     = "✚",  -- arquivo adicionado
        modified  = "",  -- arquivo modificado
        removed   = "✖",  -- arquivo deletado
        renamed   = "➜",  -- arquivo renomeado
        untracked = "★",  -- não rastreado
        ignored   = "◌",  -- ignorado
        unstaged  = "~",  -- alterações não staged
        staged    = "✔",  -- staged
        conflict  = "",  -- conflito
      },
    },
  },
  window = {
    position = "left",
    width = 35,
    focus = true
  },
  filesystem = {
    follow_current_file = { enabled = true },
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
  git_status = {
    window = {
      position = "right",
      width = 40,
    },
    enable_git_status = true, 
  },
})

local map = vim.api.nvim_set_keymap

map('n', '<leader>e', ':Neotree toggle filesystem left<CR>', { noremap = true, silent = true })
map('n', '<leader>g', ':Neotree toggle git_status right<CR>', { noremap = true, silent = true })
