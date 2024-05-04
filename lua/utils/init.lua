local M = {}

---Convert number (0/1) to boolean
---@param value number @The value to check
---@return boolean|nil @Returns nil if failed
function M.tobool(value)
  if value == 0 then
    return false
  elseif value == 1 then
    return true
  else
    vim.notify(
      "Attempting to convert data of type '" .. type(value) .. "' [other than 0 or 1] to boolean",
      vim.log.levels.ERROR,
      { title = "[utils] Runtime error" }
    )
    return nil
  end
end

---获取视觉模式范围
---@return table
function M.get_range()
  local _start = vim.fn.getpos "v"
  local _end = vim.fn.getpos "."

  local s_row, e_row = math.min(_start[2], _end[2]), math.max(_start[2], _end[2])
  local s_col, e_col = math.min(_start[3], _end[3]), math.max(_start[3], _end[3])

  return { s_row, e_row, s_col, e_col }
end

---获取v 模式下选中的文本
---@return string
function M.get_select()
  local s_row, e_row, s_col, e_col = unpack(M.get_range())

  ---@type string
  ---@diagnostic disable-next-line: assign-type-mismatch
  local line = vim.fn.getline(e_row)
  local uidx = vim.str_utfindex(line, math.min(#line, e_col))
  ---@diagnostic disable-next-line: param-type-mismatch
  e_col = vim.str_byteindex(line, uidx)

  if s_row == e_row then
    return line:sub(s_col, e_col)
  else
    local lines = vim.fn.getline(s_row, e_row)
    local e = #lines
    lines[1] = lines[1]:sub(s_col)
    lines[e] = line:sub(1, e_col)
    return table.concat(lines, " ")
  end
end

---获取V 模式下选中的行文本
---@return string
function M.get_lines()
  -- local s_row, e_row = unpack(M.get_range())
  local s_row, e_row = M.get_range()[1], M.get_range()[2]

  if s_row == e_row then
    return vim.fn.getline(s_row)
  else
    local lines = vim.fn.getline(s_row, e_row)
    return table.concat(lines, "\n")
  end
end

---转换文本内容为 url 编码格式
---@param s string
---@return string
function M.encodeURL(s)
  s = string.gsub(s, "%.", "-")
  s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
  return string.gsub(s, " ", "+")
end

---获取需要选择的文本
---@param mode string
---@return string
function M.get_text(mode)
  local text = ({
    n = function() return vim.fn.expand "<cword>" end,
    v = function() return M.get_select() end,
    V = function() return M.get_lines() end,
  })[mode]():match "^%s*(.-)%s*$"

  return M.encodeURL(text)
end

---合并键位映射表
---@param ... unknown
---@return table
function M.merge_mapping(...)
  local result = {}

  -- 遍历所有传入的映射表
  for _, mapping in ipairs { ... } do
    for mode, mode_mappings in pairs(mapping) do
      -- 如果结果中还没有这个模式的映射，则创建一个空表
      if not result[mode] then result[mode] = {} end

      -- 合并当前模式的映射
      for keybind, keybind_mapping in pairs(mode_mappings) do
        result[mode][keybind] = keybind_mapping
      end
    end
  end

  return result
end

return M
