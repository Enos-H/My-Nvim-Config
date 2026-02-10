local ok_treesitter, treesitter = pcall(require, 'nvim-treesitter.configs')

if ok_treesitter then
  treesitter.setup {
    ensure_installed = { "lua", "javascript", "typescript", "html", "css", "json", "scheme", "yuck", "java", "tsx" },
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    modules = {},

    highlight = { enable = true },
    indent = {
      enable = true,
      disable = { "yuck" },
    },
  }
end
