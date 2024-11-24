local map = require("utils").map_key

-- Convenient saving
map({ 'n' }, '<leader>w', ':w<CR>', 'Save')

-- Handy maps for common yank/paste needs
-- Taken from Primeagen and asbjornHaland's 'Greatest remaps ever'
map({ 'v' }, '<leader>P', '"_dP', 'Paste-over without capturing')
map({ 'n', 'v' }, '<leader>y', '"+y', 'Yank to system clipboard')
map({ 'n' }, '<leader>Y', 'gg"+yG', 'Yank buffer to system clipboard')
map({ 'n', 'v' }, '<leader>d', '"_d', 'Delete without capturing')

-- Quickfix jumping, in case it's needed
map({ 'n' }, "[q", vim.cmd.cprev, "Previous quickfix")
map({ 'n' }, "]q", vim.cmd.cnext, "Next quickfix")
