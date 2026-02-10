-- ==============================
-- Configurações básicas do Neovim
-- ==============================

-- Configura runtimepath para usar sua pasta config como ftplugin
vim.opt.runtimepath:append(vim.fn.stdpath('config') .. '/lua/config')

-- Define explicitamente onde procurar ftplugins
vim.g.ftplugin_dir = vim.fn.stdpath('config') .. '/lua/config'

vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.cmd("syntax on")
