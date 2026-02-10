local ok_icons, icons = pcall(require, 'nvim-web-devicons')
if ok_icons then
  icons.setup { default = true }
end
