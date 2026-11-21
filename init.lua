-- ============================
-- Neovim Config - por Enos
-- Modular e controlado
-- ============================

-- leader precisa existir antes do lazy.nvim carregar os plugins
vim.g.mapleader = " "

require("core.settings")
require("core.visuals")
require("core.plugins")
require("core.mappings")
require("core.commands")

-- plugins que precisam ser carregados após o setup do core
require("config.colorscheme")
require("config.markview")
require("config.image")
require("config.icons")
require("config.lualine")
require("config.lsp")
require("config.treesitter")
require("config.completion")
require("config.neo-tree")
require("config.neogit")
require("config.diffview")
require("config.telescope")

