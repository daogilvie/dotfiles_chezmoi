vim.filetype.add({
  pattern = {
    ['.*/Dockerfile.*'] = 'dockerfile',
  }
})
return {
  servers = {
  },
}
