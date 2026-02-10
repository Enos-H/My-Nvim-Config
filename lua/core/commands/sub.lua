-- ====================================================
-- Substituição interativa (:Sub)
-- ====================================================
local M = {}
local sub_history = {}

-- Helper
local function err(msg)
  vim.api.nvim_err_writeln("Sub: " .. msg)
end

local function escape_lua(s)
  return (s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
end

-- Parse args / flags
local function parse_args(str)
  if not str then return {} end
  local args, i, n = {}, 1, #str

  while i <= n do
    local c = str:sub(i,i)
    if c:match("%s") then
      i = i + 1
    elseif c == '"' or c == "'" then
      local quote = c
      local j, raw, val = i+1, {}, {}
      while j <= n do
        local ch = str:sub(j,j)
        if ch == "\\" then
          local nextc = str:sub(j+1,j+1) or ""
          raw[#raw+1] = "\\" .. nextc
          val[#val+1] = nextc
          j = j + 2
        elseif ch == quote then
          break
        else
          raw[#raw+1] = ch
          val[#val+1] = ch
          j = j + 1
        end
      end
      table.insert(args, { raw = table.concat(raw), value = table.concat(val), delim = quote })
      i = j + 1
    else
      local j, raw, val = i, {}, {}
      while j <= n and not str:sub(j,j):match("%s") do
        local ch = str:sub(j,j)
        if ch == "\\" then
          local nextc = str:sub(j+1,j+1) or ""
          raw[#raw+1] = "\\" .. nextc
          val[#val+1] = nextc
          j = j + 2
        else
          raw[#raw+1] = ch
          val[#val+1] = ch
          j = j + 1
        end
      end
      table.insert(args, { raw = table.concat(raw), value = table.concat(val), delim = nil })
      i = j
    end
  end

  return args
end

local function parse_flags(args)
  local force, save = false, false
  local i = 1
  while i <= #args do
    local v = args[i].value
    if v == "-f" or v == "--force" then
      force = true
      table.remove(args, i)
    elseif v == "-s" or v == "--save" then
      save = true
      table.remove(args, i)
    else
      i = i + 1
    end
  end
  return force, save, args
end

-- Patterns / replacement helpers
local function build_old_pattern_and_meta(raw)
  raw = raw or ""
  local i, n, parts, preserved_idx, capture_count = 1, #raw, {}, {}, 0

  while i <= n do
    local ch = raw:sub(i,i)
    if ch == "\\" and i < n then
      parts[#parts+1] = escape_lua(raw:sub(i+1,i+1))
      i = i + 2
    elseif ch == "$" then
      if raw:sub(i+1,i+1) == "$" then
        parts[#parts+1] = "(.-)"
        capture_count = capture_count + 1
        preserved_idx[#preserved_idx+1] = capture_count
        i = i + 2
      else
        parts[#parts+1] = "([^/]+)"
        capture_count = capture_count + 1
        preserved_idx[#preserved_idx+1] = capture_count
        i = i + 1
      end
    elseif ch == "*" then
      if raw:sub(i+1,i+1) == "*" then
        parts[#parts+1] = "(.-)"
        capture_count = capture_count + 1
        i = i + 2
      else
        parts[#parts+1] = "([^/]+)"
        capture_count = capture_count + 1
        i = i + 1
      end
    else
      parts[#parts+1] = escape_lua(ch)
      i = i + 1
    end
  end

  return table.concat(parts), preserved_idx
end

local function build_replacement_from_new(raw_new, preserved_values)
  preserved_values = preserved_values or {}
  local out, i, n, use_idx = {}, 1, #raw_new, 1

  while i <= n do
    local ch = raw_new:sub(i,i)
    if ch == "\\" and i < n then
      out[#out+1] = raw_new:sub(i+1,i+1)
      i = i + 2
    elseif ch == "$" then
      out[#out+1] = preserved_values[use_idx] or ""
      use_idx = use_idx + 1
      i = i + 1
    else
      out[#out+1] = ch
      i = i + 1
    end
  end

  return table.concat(out)
end

-- Lines / files processing
local function replace_in_lines(lines, pattern, preserved_idx, raw_new, force, filename)
  local replaced, out_lines = 0, {}
  local match_pattern = "(" .. pattern .. ")"

  for lnum, line in ipairs(lines) do
    local new_line, start_idx = line, 1

    while true do
      local sub = new_line:sub(start_idx)
      if sub == "" then break end
      local find_s, find_e = sub:find(match_pattern)
      if not find_s then break end

      local abs_s = start_idx + find_s - 1
      local abs_e = start_idx + find_e - 1
      local matched_sub = sub:sub(find_s, find_e)

      local caplist = { string.match(matched_sub, "^" .. pattern .. "$") }
      local preserved_values = {}
      for _, idx in ipairs(preserved_idx) do
        preserved_values[#preserved_values + 1] = caplist[idx] or ""
      end

      local replacement = build_replacement_from_new(raw_new, preserved_values)

      if not force then
        vim.api.nvim_out_write(string.format("File: %s | Line %d: %s\nReplace '%s' -> '%s'\n",
          filename or "(buffer)", lnum, new_line, matched_sub, replacement))
        local ans = vim.fn.input("Replace this occurrence? (y/n/q) ")
        if ans:lower() == "n" then
          start_idx = abs_e + 1
          goto continue_inner
        elseif ans:lower() == "q" then
          return nil, -1
        end
      end

      new_line = new_line:sub(1, abs_s-1) .. replacement .. new_line:sub(abs_e+1)
      replaced = replaced + 1
      start_idx = abs_s + #replacement

      ::continue_inner::
    end

    out_lines[#out_lines+1] = new_line
  end

  return out_lines, replaced
end

local function process_file(path, old_raw, new_raw, force, save)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then err("Failed to read file: " .. path) return 0, false end

  local pattern, preserved_idx = build_old_pattern_and_meta(old_raw)
  local new_lines, replaced = replace_in_lines(lines, pattern, preserved_idx, new_raw, force, path)
  if not new_lines then
    if replaced == -1 then return -1, false end
    return 0, false
  end

  if replaced > 0 and save then
    local okw, werr = pcall(vim.fn.writefile, new_lines, path)
    if not okw then
      err("Failed to write file: " .. path)
      return replaced, false
    end
  end

  return replaced, true
end

local function expand_glob(glob)
  return vim.fn.glob(glob, false, true)
end

-- Main interactive Sub
local function interactive_sub(args_str)
  local raw_args = parse_args(args_str)
  if #raw_args == 0 then
    err("Nenhum argumento fornecido.")
    return
  end

  local force, save, args = parse_flags(raw_args)

  -- detect mode
  local idx, mode = 1, nil
  local first = args[1] and args[1].value or nil
  if first == "-g" or first == "--global" then
    mode = "global"; idx = 2
  elseif first == "-l" or first == "--local" then
    mode = "local"; idx = 2
  else
    mode = "global"
  end

  -- local mode
  if mode == "local" then
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local i, total = idx, 0

    while i <= #args do
      local old_tbl, new_tbl = args[i], args[i+1]
      if not old_tbl then break end
      local new_raw = (new_tbl and new_tbl.raw) or ""
      local pattern, preserved_idx = build_old_pattern_and_meta(old_tbl.raw)
      local new_lines, replaced = replace_in_lines(lines, pattern, preserved_idx, new_raw, force, filename)
      if not new_lines and replaced == -1 then
        print("Substituição cancelada pelo usuário")
        return
      end
      if replaced > 0 then
        lines = new_lines
        total = total + replaced
        pcall(vim.api.nvim_buf_set_lines, bufnr, 0, -1, false, lines)
        if save then vim.api.nvim_command("write") end
        table.insert(sub_history, { mode = "local", old = old_tbl.value, new = new_tbl and new_tbl.value or "", force = force, save = save, file = filename })
      end
      i = i + 2
    end

    print(string.format("Substituições feitas (local): %d", total))
    return
  end

  -- global mode
  local glob_arg = args[idx] and args[idx].value
  if not glob_arg then err("Glob de arquivos não fornecido para modo global.") return end
  local files = expand_glob(glob_arg)
  if #files == 0 then print("Nenhum arquivo encontrado para: " .. glob_arg) return end

  local i, total_replacements = idx + 1, 0
  while i <= #args do
    local old_tbl, new_tbl = args[i], args[i+1]
    if not old_tbl then break end
    local new_raw = (new_tbl and new_tbl.raw) or ""
    for _, path in ipairs(files) do
      local replaced, ok = process_file(path, old_tbl.raw, new_raw, force, save)
      if replaced == -1 then print("Substituição cancelada pelo usuário") return end
      if replaced and replaced > 0 then
        total_replacements = total_replacements + replaced
        table.insert(sub_history, { mode = "global", old = old_tbl.value, new = new_tbl and new_tbl.value or "", force = force, save = save, file = path })
      end
    end
    i = i + 2
  end

  print(string.format("Total de substituições (global): %d", total_replacements))
end

-- Commands
vim.api.nvim_create_user_command("Sub", function(opts)
  interactive_sub(opts.args)
end, { nargs = "*", complete = "file", desc = "Substituição interativa com wildcards *, **, $, $$ (escape com \\), flags -f -s -g -l" })

vim.api.nvim_create_user_command("Subh", function()
  if #sub_history == 0 then print("Nenhuma substituição feita ainda") return end
  for i, h in ipairs(sub_history) do
    local info = h.file or "no arquivo atual"
    print(string.format("%d: [%s] %s -> %s em %s%s%s", i, h.mode, h.old, h.new, info, h.force and " (force)" or "", h.save and " (save)" or ""))
  end
end, { nargs = 0, desc = "Mostra histórico das substituições feitas com :Sub" })

-- expose
M.interactive_sub = interactive_sub
M.parse_args = parse_args
M.build_old_pattern_and_meta = build_old_pattern_and_meta

return M
