local utils = require('languages._utils')
return {
  on_attach = utils.on_attach,
  init_options = { hostInfo = "neovim" },
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = {
    "python",
  },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true
      }
    }
  }
}
