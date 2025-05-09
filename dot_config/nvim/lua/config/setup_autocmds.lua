local function make_augroup(name)
  return vim.api.nvim_create_augroup("dao_" .. name, { clear = true })
end

-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = make_augroup "YankHighlight",
    pattern = "*",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- As per tiny.nvim, wrap and spell check in "text" types
vim.api.nvim_create_autocmd("FileType", {
  group = make_augroup "wrap_spell",
  pattern = { "*.txt", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
