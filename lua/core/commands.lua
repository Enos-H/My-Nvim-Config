-- ====================================================
-- core/commands.lua
-- Indexa todos os comandos do Neovim
-- ====================================================

local M = {}

-- Lista de arquivos de comandos
local commands = {
  "core.commands.sub",
  "core.commands.reloads",
}

for _, cmd in ipairs(commands) do
  local ok, _ = pcall(require, cmd)
  if not ok then
    vim.api.nvim_err_writeln("Erro ao carregar comando: " .. cmd)
  end
end

return M
