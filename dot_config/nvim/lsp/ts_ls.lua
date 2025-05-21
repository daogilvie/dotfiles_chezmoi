local utils = require('languages._utils')
return {
  on_attach = utils.on_attach,
  init_options = { hostInfo = "neovim" },
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
  settings = {
    typescript = require('languages.typescript').servers.ts_ls.lsp_config,
    javascript = require('languages.javascript').servers.ts_ls.lsp_config,
    diagnostics = { ignoredCodes = { 80001 } },
  }
}
