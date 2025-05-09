local utils = require('languages._utils')
-- identify docker compose files specifically
vim.filetype.add({
  filename = {
    ['docker-compose.yml'] = 'yaml.docker-compose',
    ['docker-compose.yaml'] = 'yaml.docker-compose',
  }
})
return {
  servers = {
    compose_language_service = {
      lsp_config = {
        cmd = { 'docker-compose-langserver', '--stdio' },
        on_attach = utils.on_attach,
        filetypes = { 'yaml.docker-compose' },
        root_markers = { 'docker-compose.yml', 'docker-compose.yaml' },
      }
    },
    yaml_ls = {
      lsp_config = {
        cmd = { 'yaml-language-server', '--stdio' },
        on_attach = utils.on_attach,
        filetypes = { 'yaml', 'yaml.docker-compose' },
        single_file_support = true,
      }
    }
  },
}
