local luapath = vim.fn.stdpath('config') .. '/lua/'
local path = luapath .. ...
local M = {}

for _, filepath in pairs(vim.split(vim.fn.glob(path .. '/*'), '\n')) do
  -- convert absolute filename to relative
  -- ~/.config/nvim/lua/<package>/<module>.lua => <package>/foo
  local relfilename = filepath:gsub(luapath, ''):gsub('/', '.'):sub(0, -5)

  local basename = relfilename:sub(11)
  if (basename ~= 'init' and basename:sub(1, 1) ~= '_') then
    M[basename] = require(relfilename)
  end
end
return M
