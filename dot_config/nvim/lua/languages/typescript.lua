return {
  servers = {
    ts_ls =
    {
      lsp_config = {
        inlayHints = "all",
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
          showOnAllFunctions = true,
        },
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
      },
    }
  },
  neogen = {
    template = {
      annotation_convention = "tsdoc"
    },
  }
}
