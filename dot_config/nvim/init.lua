require "config.setup_core"
require "config.setup_lazy"
require "config.setup_keymaps"
require "config.setup_autocmds"

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require "config.setup_languages"
  end,
})
