local languages = require('languages')

local modules = {
    -- Debugging and Testing
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "rcarriga/nvim-dap-ui" },
            { "theHamsta/nvim-dap-virtual-text" },
            { "nvim-telescope/telescope-dap.nvim" },
            { "jay-babu/mason-nvim-dap.nvim" },
            { "nvim-neotest/nvim-nio" }
        },
        keys = {
            { "<leader>dR", function() require("dap").run_to_cursor() end,     desc = "Run to Cursor", },
            {
                "<leader>dE",
                function() require("dapui").eval(vim.fn.input "[Expression] > ") end,
                desc =
                "Evaluate Input",
            },
            {
                "<leader>dB",
                function() require("dap").toggle_breakpoint() end,
                desc =
                "Toggle Breakpoint",
            },
            {
                "<leader>dC",
                function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end,
                desc =
                "Conditional Breakpoint",
            },
            {
                "<leader>dU",
                function() require("dapui").toggle() end,
                desc =
                "Toggle UI",
            },
            {
                "<leader>db",
                function() require("dap").step_back() end,
                desc =
                "Step Back",
            },
            {
                "<leader>dc",
                function() require("dap").continue() end,
                desc =
                "Continue",
            },
            {
                "<leader>dd",
                function() require("dap").disconnect() end,
                desc =
                "Disconnect",
            },
            {
                "<leader>de",
                function() require("dapui").eval() end,
                mode = { "n",
                    "v" },
                desc =
                "Evaluate",
            },
            {
                "<leader>dg",
                function() require("dap").session() end,
                desc =
                "Get Session",
            },
            {
                "<leader>dh",
                function() require("dap.ui.widgets").hover() end,
                desc =
                "Hover Variables",
            },
            { "<leader>dS", function() require("dap.ui.widgets").scopes() end, desc = "Scopes", },
            {
                "<leader>di",
                function() require("dap").step_into() end,
                desc =
                "Step Into",
            },
            {
                "<leader>do",
                function() require("dap").step_over() end,
                desc =
                "Step Over",
            },
            {
                "<leader>dl",
                function() require("dap").run_last() end,
                desc =
                "Run Last"
            },
            { "<leader>dp", function() require("dap").pause.toggle() end, desc = "Pause", },
            { "<leader>dq", function() require("dap").close() end,        desc = "Quit", },
            {
                "<leader>dr",
                function() require("dap").repl.toggle() end,
                desc =
                "Toggle REPL",
            },
            {
                "<leader>ds",
                function()
                    require("dap").continue()
                end,
                desc = "Start",
            },
            {
                "<leader>dx",
                function() require("dap").terminate() end,
                desc =
                "Terminate",
            },
            {
                "<leader>du",
                function() require("dap").step_out() end,
                desc =
                "Step Out",
            },
        },
        opts = {
            setup = {},
        },
        config = function(plugin, opts)
            local icons = require "config.icons"
            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

            for name, sign in pairs(icons.dap) do
                sign = type(sign) == "table" and sign or { sign }
                vim.fn.sign_define("Dap" .. name,
                    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] })
            end

            require("nvim-dap-virtual-text").setup {
                commented = true,
            }

            local dap, dapui = require "dap", require "dapui"
            dapui.setup {}

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- set up debugger
            for k, _ in pairs(opts.setup) do
                opts.setup[k](plugin, opts)
            end
        end,
    },
    {
        "vim-test/vim-test",
        config = function()
            vim.g["test#strategy"] = "neovim"
            vim.g["test#neovim#term_position"] = "belowright"
            vim.g["test#neovim#preserve_screen"] = 1
            vim.g["test#python#runner"] = "pytest"
        end,
    },
    {
        "nvim-neotest/neotest",
        keys = {
            -- This freezes so I'm turning it off until I know why
            -- {
            --     '<leader>ts',
            --     function() require('neotest').summary.toggle() end,
            --     desc = "Toggle Neotest Summary"
            -- },
            { '<leader>tf', function() require('neotest').run.run(vim.fn.expand("%")) end, desc = "Test current file" },
            { '<leader>tr', function() require('neotest').run.run() end,                   desc = "Run test" },
            { '<leader>to', function() require('neotest').output.open() end,               desc = "Open Test Output" },
            {
                "<leader>tD",
                function() require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' }) end,
                desc = "Debug File"
            },
            {
                "<leader>td",
                function() require('neotest').run.run({ strategy = 'dap' }) end,
                desc = "Debug test"
            },
        },
        dependencies = {
            "nvim-neotest/neotest-plenary",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-vim-test",
            "vim-test/vim-test",
        },
        opts = function()
            local adapters = {
                require('neotest-plenary'),
                require('neotest-vim-test') {
                    ignore_file_types = { "python", "vim", "lua" },
                },
            }
            for _, language in pairs(languages) do
                if language.test_adapters then
                    vim.list_extend(adapters, language.test_adapters())
                end
            end
            return {
                adapters = adapters,
                status = { virtual_text = true },
                output = { open_on_run = true },
                quickfix = {
                    open = function()
                        if require("utils").has "trouble.nvim" then
                            vim.cmd "Trouble quickfix"
                        else
                            vim.cmd "copen"
                        end
                    end,
                },
                -- overseer.nvim
                consumers = {
                    overseer = require "neotest.consumers.overseer",
                },
                overseer = {
                    enabled = true,
                    force_default = true,
                },
            }
        end,
        config = function(_, opts)
            local neotest_ns = vim.api.nvim_create_namespace "neotest"
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+",
                            "")
                        return message
                    end,
                },
            }, neotest_ns)
            require("neotest").setup(opts)
        end,
    },
    {
        "Equilibris/nx.nvim",

        dependencies = {
            "nvim-telescope/telescope.nvim",
        },

        opts         = {
            -- See below for config options
            nx_cmd_root = "nx",
        },

        -- Plugin will load when you use these keys
        keys         = {
            { "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "nx actions" }
        },
    },
    {
        'dhleong/trot.nvim',
        keys = { { "<leader>K", function() require('trot').search() end, desc = "Search Dash" } }
    }
}

-- Pull the modules from the programming files
for _, language in pairs(languages) do
    vim.list_extend(modules, language.modules)
end

return modules
