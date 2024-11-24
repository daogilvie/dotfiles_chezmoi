return {
    modules = {},
    servers = function () return {
        lua_ls = {
            settings = {
                Lua = {
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { 'vim' },
                    },
                    workspace = {
                        checkThirdParty = false,
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file('', true),
                    },
                    completion = { callSnippet = "Replace" },
                    telemetry = { enable = false },
                    hint = {
                        enable = false,
                    },
                },
            },
        },
    }
  end
}
