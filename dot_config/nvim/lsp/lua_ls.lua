local utils = require('languages._utils')
return {
  cmd = { 'lua-language-server' },
  on_attach = utils.on_attach,
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
}
