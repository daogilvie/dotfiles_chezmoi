local opt = vim.opt

-- Disable swap/backup
opt.backup = false
opt.wb = false
opt.swapfile = false
opt.autoread = true

-- Don't need modelines
opt.modeline = false
opt.modelines = 0

-- But I do want to persist undo buffers to disk
opt.undofile = true

-- Sane, friendly search behaviour
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Splits are placed under/to-the-right
opt.splitbelow = true
opt.splitright = true

-- I tend to find spaces everywhere is a good default
-- and outsource any language-specific settings to
-- editorconfig
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.copyindent = true

-- Fold things via indent in the default case
opt.foldmethod = 'indent'
opt.foldlevel = 4

-- I'm a brit
opt.spelllang = 'en_gb'

-- No wrapping, with nicer scroll behaviour
opt.wrap = false
opt.sidescroll = 5
opt.scrolloff = 5

-- Tweak nvim built-in text formatter
-- Based on TJDevries config:
-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/plugin/options.lua
opt.formatoptions = opt.formatoptions
    -- No need for weird paragraph indentation.
    - "2"
    -- Disable builtin autoformatting
    - "a"
    - "t"
    -- Comment handling niceties
    + "j"
    + "q"
    -- Comment leader auto-insertion in all cases
    + "o"
    + "r"
    -- Indented lists
    + "n"

-- I am impatient
opt.timeout = true
opt.timeoutlen = 300

-- Line numbers with toggling
opt.number = true
opt.relativenumber = true
local numbertoggle_ag = vim.api.nvim_create_augroup('RelAbsLineToggle', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave' },
  { group = numbertoggle_ag, command = 'set relativenumber' })
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter' },
  { group = numbertoggle_ag, command = 'set norelativenumber' })

-- Place a ruler at column 80
opt.colorcolumn = '80'

-- I use Space and Comma as leader and local leader respectively
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[,]]

-- Make sure to add the mise shims to path,
-- but after the lua 5.1 install required by lazy
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/installs/lua/5.1/bin:" .. vim.env.PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/installs/lua/5.1/luarocks/bin:" .. vim.env.PATH

-- Providers
vim.g.python3_host_prog = vim.env.HOME .. "/.local/share/nvim/venv/bin/python"
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Package local exrc
-- Mostly used for overseer tasks
vim.o.exrc = true
