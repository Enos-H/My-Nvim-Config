-- =====================================
--   Gerenciador de Plugins: lazy.nvim
-- =====================================

-- Bootstrap automático do lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Falha ao clonar lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- -------------------------------------
    --  Aparência e Interface
    -- -------------------------------------
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lualine/lualine.nvim" },
    { "morhetz/gruvbox" },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "OXY2DEV/markview.nvim" },  -- Preview de Markdown/LaTeX/Typst/YAML
    { "3rd/image.nvim" },         -- Renderiza imagens (mermaid, svg, png) no buffer

    -- -------------------------------------
    --  Syntax Highlighting & Parsing
    -- -------------------------------------
    { "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate" },

    -- -------------------------------------
    --  LSP
    -- -------------------------------------
    { "neovim/nvim-lspconfig" },
    { "mason-org/mason.nvim" },
    { "mason-org/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },

    -- -------------------------------------
    --  Fuzzy Finder e Navegação
    -- -------------------------------------
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-file-browser.nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
    { "junegunn/fzf", build = "./install --bin" },
    { "junegunn/fzf.vim" },

    -- -------------------------------------
    --  Autocompletar e Snippets
    -- -------------------------------------
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },

    -- -------------------------------------
    --  Explorador de Arquivos
    -- -------------------------------------
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    },

    -- -------------------------------------
    --  Git
    -- -------------------------------------
    { "NeogitOrg/neogit", dependencies = { "sindrets/diffview.nvim", "nvim-lua/plenary.nvim" } },
    { "sindrets/diffview.nvim" },

    -- -------------------------------------
    --  S-expressions (Yuck)
    -- -------------------------------------
    { "guns/vim-sexp" },
    { "tpope/vim-sexp-mappings-for-regular-people" },

    -- -------------------------------------
    --  Java + Spring Boot + Maven
    -- -------------------------------------
    { "mfussenegger/nvim-dap" },
    { "mfussenegger/nvim-jdtls" },  -- configurado em ftplugin/java.lua
    { "nvim-lua/plenary.nvim" },
    { "MunifTanjim/nui.nvim" },
    {
      "oclay1st/maven.nvim",
      cmd = { "Maven", "MavenInit" },
      dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
      config = true,
    },
  },
  -- Plugins carregam no startup (os módulos config.* esperam isso)
  defaults = { lazy = false },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  rocks = { enabled = false },  -- luarocks não está instalado
})
