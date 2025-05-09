-- TSV files need to retain tabs, obvs
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('FT_overrides', { clear = true }),
  pattern = '*.tsv',
  callback = function()
    vim.bo.expandtab = false
  end,
})
return {
  servers = {
  },
}
