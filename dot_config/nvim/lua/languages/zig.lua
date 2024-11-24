local M = {}

M.servers = function()
    return {
        zls = {},
    }
end

M.modules = {
    {
        "mfussenegger/nvim-dap",
        opts = {
            setup = {
                codelldb = function(plugin, opts)
                    local lldbpath = require('mason-registry').get_package('codelldb'):get_install_path()
                    local dap = require('dap')
                    dap.adapters.codelldb = {
                        type = 'server',
                        port = "${port}",
                        executable = {
                            command = lldbpath .. '/codelldb',
                            args = { "--port", "${port}" },
                        }
                    }
                    dap.configurations.zig = {
                        {
                            name = "Launch file",
                            type = "codelldb",
                            request = "launch",
                            program = function()
                                --  Attempt to be clever
                                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/zig-out/bin/', 'file')
                            end,
                            cwd = '${workspaceFolder}',
                            stopOnEntry = false,
                        },
                    }
                end
            }
        },
        ft = "zig"
    },
    {
        "stevearc/overseer.nvim",
        opts = function(_, opts)
            opts.templates = vim.list_extend(opts.templates, { "zig.debug_build" })
        end
    }
}

M.test_adapters = function()
    return {
    }
end

return M
