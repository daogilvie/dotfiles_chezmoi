--- Install lazy.nvim if not already present
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup("plugins", {
  defaults = { lazy = true, version = nil },
  install = { missing = true, colorscheme = { "catppucin-mocha" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tutor",
      },
    },
  }
})

vim.keymap.set("n", "<leader>z", "<cmd>:Lazy<cr>", { desc = "Plugin Manager" })
