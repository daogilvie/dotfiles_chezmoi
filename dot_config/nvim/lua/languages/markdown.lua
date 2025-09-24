local utils = require('languages._utils')
return {
  servers = {
    marksman = {
      lsp_config = {
        cmd = { 'marksman', 'server' },
        on_attach = utils.on_attach,
        filetypes = { 'markdown' },
        root_markers = { '.marksman.toml', '.git' },
      }
    },
    codebook = {}
  },
}
