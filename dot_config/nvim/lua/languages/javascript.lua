-- identify oxlint files as jsonc
vim.filetype.add({
  filename = {
    ['.oxlintrc.json'] = 'jsonc'
  }
})
return {
  servers = {
    ts_ls = {
      -- Inlay Hints preferences
      inlayHints = {
        -- You can set this to 'all' or 'literals' to enable more hints
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
        includeInlayVariableTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      -- Code Lens preferences
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
      completions = {
        completeFunctionCalls = true,
      },
    }
  },
  neogen = {
    template = {
      annotation_convention = "js_doc"
    },
  }
}
