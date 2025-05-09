-- Quick access to lazy
vim.keymap.set({ 'n' }, '<leader>z', '<cmd>:Lazy<cr>', { desc = 'Plugin Manager' })

-- Convenient saving
vim.keymap.set({ 'n' }, '<leader>w', ':w<CR>', { desc = 'Save' })

-- Handy maps for common yank/paste needs
-- Taken from Primeagen and asbjornHaland{ desc = 's 'Greatest remaps ever'
vim.keymap.set({ 'v' }, '<leader>P', '"_dP', { desc = 'Paste-over without capturing' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set({ 'n' }, '<leader>Y', 'gg"+yG', { desc = 'Yank buffer to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete without capturing' })

-- Quickfix jumping, in case it's needed
vim.keymap.set({ 'n' }, '[q', vim.cmd.cprev, { desc = 'Previous quickfix' })
vim.keymap.set({ 'n' }, ']q', vim.cmd.cnext, { desc = 'Next quickfix' })
