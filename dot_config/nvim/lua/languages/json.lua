local utils = require('languages._utils')
return {
  servers = {
    json_ls = {
      lsp_config = {
        cmd = { 'vscode-json-languageserver', '--stdio' },
        on_attach = utils.on_attach,
        filetypes = { 'json', 'jsonc' },
        init_options = {
          provideFormatter = true,
        },
        root_markers = { 'package.json' },
        single_file_support = true,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          }
        }
      }
    },
  }
}
