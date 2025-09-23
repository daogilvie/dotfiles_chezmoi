local utils = require('languages._utils')
return {
  cmd = { 'docker-language-server', 'start', '--stdio' },
  on_attach = utils.on_attach,
  filetypes = { 'yaml.docker-compose', 'dockerfile' },
  root_markers = { 'docker-compose.yml', 'docker-compose.yaml' },
}
