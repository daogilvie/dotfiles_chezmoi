local utils = require('languages._utils')
return {
  servers = {
    lua_ls = {
      lsp_config = {
        cmd = { 'lua-language-server' },
        on_attach = utils.on_attach,
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc' },
      }
    }
  },
  neogen = {
    template = {
      annotation_convention = "ldoc",
    },
  }
}
