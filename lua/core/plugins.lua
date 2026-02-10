-- =====================================
--   Gerenciador de Plugins: packer.nvim
-- =====================================

--  Bootstrap automático do packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
vim.cmd [[packadd packer.nvim]]

-- =====================================
--  Plugins
-- =====================================
return require('packer').startup(function(use)

  --  Packer pode se atualizar
  use { 'wbthomason/packer.nvim' }

  -- -------------------------------------
  --  Aparência e Interface
  -- -------------------------------------
  use { 'nvim-tree/nvim-web-devicons' }   -- Ícones
  use { 'nvim-lualine/lualine.nvim' }     -- Barra de status (statusline)
  use { 'morhetz/gruvbox' }
  use { 'catppuccin/nvim', as = 'catppuccin' }


  -- -------------------------------------
  --  Syntax Highlighting & Parsing
  -- -------------------------------------
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }

  -- -------------------------------------
  --  LSP (Language Server Protocol)
  -- -------------------------------------
  use {
    'neovim/nvim-lspconfig',
    tag = 'v0.1.7',
  }

  -- -------------------------------------
  --  Fuzzy Finder e Navegação
  -- -------------------------------------
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  use {
    'nvim-telescope/telescope-file-browser.nvim',
    requires = { 'nvim-telescope/telescope.nvim' },
  }

  -- Alternativa FZF (busca ultrarrápida)
  use { 'junegunn/fzf', run = './install --bin' }
  use { 'junegunn/fzf.vim' }

  -- -------------------------------------
  --  Autocompletar e Snippets
  -- -------------------------------------
  -- Engine principal
  use { 'hrsh7th/nvim-cmp' }

  -- Fontes de autocomplete
  use { 'hrsh7th/cmp-nvim-lsp' }  -- integração com LSP
  use { 'hrsh7th/cmp-buffer' }    -- palavras do buffer
  use { 'hrsh7th/cmp-path' }      -- caminhos de arquivo
  use { 'hrsh7th/cmp-cmdline' }   -- comandos do Vim

  -- Snippets
  use { 'L3MON4D3/LuaSnip' }              -- mecanismo de snippets
  use { 'saadparwaiz1/cmp_luasnip' }      -- integração cmp + luasnip

  -- -------------------------------------
  --  Explorador de Arquivos
  -- -------------------------------------
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  }

  -- -------------------------------------
  --  Git & Controle de Versão
  -- -------------------------------------
  use { "NeogitOrg/neogit", requires = { "sindrets/diffview.nvim", "nvim-lua/plenary.nvim" } }
  use { "sindrets/diffview.nvim" }

   -- Plugin para editar s-expressions melhor (útil para Yuck)
  use 'guns/vim-sexp'
  use 'tpope/vim-sexp-mappings-for-regular-people'

  -- Plugin parinfer para ajudar na indentação lisp-like
  use { 'eraserhd/parinfer-rust', run = 'cargo build --release' }

  -- -------------------------------------
  --  Github Copilot
  -- ------------------------------------- 
  use {
    'github/copilot.vim',
    branch = 'release'
  }

   -- -------------------------------------
  --  JAVA + SPRING BOOT + MAVEN
  -- -------------------------------------
  use { 'mfussenegger/nvim-dap' }
  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim' }
  use { 'WhoIsSethDaniel/mason-tool-installer.nvim' }
  use { 'mfussenegger/nvim-jdtls' }
  use { 'nvim-lua/plenary.nvim' }
  use { 'MunifTanjim/nui.nvim' }
  use {
    'oclay1st/maven.nvim',
    requires = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
    cmd = { 'Maven', 'MavenInit' },
  }

  -- -------------------------------------
  --  Sincronização automática após instalar
  -- -------------------------------------
  if packer_bootstrap then
    require('packer').sync()
  end

end)
