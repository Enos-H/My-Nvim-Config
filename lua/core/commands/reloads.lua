-- ====================================================
-- Comandos de recarregar módulos e plugins
-- ====================================================
local M = {}

-- Recarregar um módulo específico
vim.api.nvim_create_user_command("ReloadModule", function(opts)
  local module_name = opts.args
  if module_name == "" then
    print("Use: :ReloadModule <module_name>")
    return
  end
  package.loaded[module_name] = nil
  require(module_name)
  print("Módulo '" .. module_name .. "' recarregado!")
end, { nargs = 1 })

-- Recarregar um plugin específico
vim.api.nvim_create_user_command("ReloadPlugin", function(opts)
  local plugin_name = opts.args
  if plugin_name == "" then
    print("Use: :ReloadPlugin <plugin_name>")
    return
  end
  package.loaded[plugin_name] = nil
  require(plugin_name)
  print("Plugin '" .. plugin_name .. "' recarregado!")
end, { nargs = 1 })


vim.api.nvim_create_user_command("ReloadPlugins", function()
  local config_path = vim.fn.stdpath("config") .. "/lua/config"
  local handle = vim.loop.fs_scandir(config_path)
  if not handle then return end

  while true do
    local name, typ = vim.loop.fs_scandir_next(handle)
    if not name then break end
    if typ == "file" and name:sub(-4) == ".lua" then
      local mod_name = "config." .. name:sub(1, -5) -- remove ".lua"
      package.loaded[mod_name] = nil
      require(mod_name)
    end
  end

  print("Todos os plugins recarregados automaticamente!")
end, {})

-- Recarregar todos os módulos do core
vim.api.nvim_create_user_command("ReloadCore", function()
  for name,_ in pairs(package.loaded) do
    if name:match("^core") then
      package.loaded[name] = nil
      require(name)
    end
  end
  print("Todos os módulos do core recarregados!")
end, {})

-- Recarregar todo o Neovim
vim.api.nvim_create_user_command("ReloadNvim", function()
  for name,_ in pairs(package.loaded) do
    if name:match("^core") or name:match("^config") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.fn.stdpath("config").."/init.lua")
  print("Neovim recarregado completamente!")
end, {})

return M


