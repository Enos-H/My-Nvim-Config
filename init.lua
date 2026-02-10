-- ============================
-- Neovim Config - por Enos
-- Modular e controlado
-- ============================

-- Define <Leader> como espaço
vim.g.mapleader = ' '


-- no init.lua
require("core.settings")
require("core.visuals")
require("core.plugins")
require("core.mappings")
require("core.commands")

-- plugins que precisam ser carregados após o setup do core
require("config.java")
require("config.colorscheme")
require("config.icons")
require("config.lualine")
require("config.lsp")
require("config.completion")
require("config.neo-tree")
require("config.neogit")
require("config.diffview")
require("config.telescope")

