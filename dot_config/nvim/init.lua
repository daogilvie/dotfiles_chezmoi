-- This file contains core vim/nvim settings that apply everywhere
require "config.setup_core"
require "config.setup_lazy"

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require "config.setup_autocmds"
        require "config.setup_keymaps"
    end,
})
