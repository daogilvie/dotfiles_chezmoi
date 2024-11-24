local M = {}
function M.map_key(modes, shortcut, command_or_fn, desc)
    vim.keymap.set(modes, shortcut, command_or_fn, { noremap = true, silent = true, desc = desc})
end
return M
