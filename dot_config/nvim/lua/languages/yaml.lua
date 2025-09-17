local utils = require('languages._utils')
vim.filetype.add({
  -- identify docker compose files specifically
  filename = {
    ['docker-compose.yml'] = 'yaml.docker-compose',
    ['docker-compose.yaml'] = 'yaml.docker-compose',
  },
  pattern = {
    -- identify gha workflows specifically
    ['.*/.github/workflows/.*%.ya-ml'] = 'yaml.gha',
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
        filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gha' },
        single_file_support = true,
      }
    },
    ['helm-ls'] = {
      lsp_config = {
        cmd = { 'helm_ls', 'serve' },
        filetypes = { 'helm' },
        on_attach = utils.on_attach,
      }
    }
  },
}
