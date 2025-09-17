local utils = require('languages._utils')
-- To install: go install golang.org/x/tools/gopls@latest
return {
  on_attach = utils.on_attach,
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.mod', 'go.sum', 'go.work', '.git' },
  settings = {
    gopls = require('languages.go').servers.gopls
  }
}
