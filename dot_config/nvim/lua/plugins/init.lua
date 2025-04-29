-- Contains any modules that are universally applicable, or have hardly any config
return {
    { "nvim-lua/plenary.nvim" }, -- This provides utility functions for other plugins
    {
        "loctvl842/monokai-pro.nvim",
        config = function()
            require("monokai-pro").setup({
                filter = "spectrum",
                background_clear = {
                    "notify",
                    "telescope",
                    "which-key",
                },
                plugins = {
                    notify = {}
                }
            })
            vim.cmd([[colorscheme monokai-pro]])
        end,
        lazy = false,
        priority = 1000,
    },
    "MunifTanjim/nui.nvim",   -- This provides UI elements for other plugins
    {
        "stevearc/dressing.nvim", -- As does this
        event = "VeryLazy",
        opts = {
            input = { relative = "editor" },
            select = {
                backend = { "telescope", "fzf", "builtin" },
            },
        },
    },
    -- Nice notifcations
    {
        "rcarriga/nvim-notify",
        lazy = false,
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
        config = function(_, opts)
            local filter = require("monokai-pro.colorscheme").filter
            ---@module "monokai-pro.colorscheme.palette.pro"
            local c = require("monokai-pro.colorscheme.palette." .. filter)
            opts.background_color = c.background
            require("notify").setup(opts)
            vim.notify = require "notify"
        end,
        dependencies = {
            "loctvl842/monokai-pro.nvim",
        }
    },
    {
        "nvim-tree/nvim-web-devicons",
        opts = { default = true },
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    -- The obligatory folke section
    -- Nicer diagnostics
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            {
                "<leader>xt",
                "<cmd>Trouble telescope toggle<cr>",
                desc =
                "Toggle Trouble"
            },
            {
                "<leader>xs",
                "<cmd>Trouble symbols toggle pinned=true win.relative=win win.position=right<cr>",
                desc =
                "Trouble document symbols"
            },
            {
                "<leader>xf",
                "<cmd>Trouble telescope_files toggle<cr>",
                desc =
                "Toggle Trouble"
            },
            {
                "<leader>xw",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc =
                "Workspace diagnostics"
            },
            {
                "<leader>xd",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc =
                "Document diagnostics"
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
            {
                "]x",
                function() require("trouble").next({ skip_groups = true, jump = true }); end,
                desc = "Next Trouble Item"
            },
            {
                "[x",
                function() require("trouble").prev({ skip_groups = true, jump = true }); end,
                desc = "Previous Trouble Item"
            }
        }
    },
    -- Used to use tpope's Obsession.vim but giving the below a try now for session management
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
        keys = {
            { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            {
                "<leader>qd",
                function() require("persistence").stop() end,
                desc =
                "Don't Save Current Session"
            },
        },
    },
    -- Well regarded task runner.
    {
        "stevearc/overseer.nvim",
        keys = {
            { "<leader>rR", "<cmd>OverseerRunCmd<cr>",       desc = "Run Command" },
            { "<leader>ra", "<cmd>OverseerTaskAction<cr>",   desc = "Task Action" },
            { "<leader>rb", "<cmd>OverseerBuild<cr>",        desc = "Build" },
            { "<leader>rc", "<cmd>OverseerClose<cr>",        desc = "Close" },
            { "<leader>rd", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
            { "<leader>rl", "<cmd>OverseerLoadBundle<cr>",   desc = "Load Bundle" },
            { "<leader>ro", "<cmd>OverseerOpen<cr>",         desc = "Open" },
            { "<leader>rq", "<cmd>OverseerQuickAction<cr>",  desc = "Quick Action" },
            { "<leader>rr", "<cmd>OverseerRun<cr>",          desc = "Run" },
            { "<leader>rs", "<cmd>OverseerSaveBundle<cr>",   desc = "Save Bundle" },
            { "<leader>rt", "<cmd>OverseerToggle<cr>",       desc = "Toggle" },
        },
        lazy = false,
        opts = {
            templates = { "builtin", "zig", "git" }
        },
        config = function(_, opts)
            local overseer = require('overseer')
            overseer.setup(opts)
            overseer.add_template_hook({ module = "^make$" }, function(task_defn)
                -- We use gmake because it's newer and better
                task_defn.cmd = "gmake"
            end)
        end,
    },
    -- So apparently this makes directory navigation a breeze
    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function(_, opts)
            require("oil").setup()
        end,
        keys = {
            { '-', '<cmd>Oil<CR>', desc = 'Run oil in current buffer dir' }
        },
        event = "VeryLazy"
    },
    {
        'MagicDuck/grug-far.nvim',
        config = function()
            require('grug-far').setup({
            });
        end,
        keys = {
            { '<leader>S', '<cmd>lua require("grug-far").open()<CR>', desc = "Open grug-far" }
        },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {
            search = {
                mode = "fuzzy",
                exclude = {
                    "notify",
                    "cmp_menu",
                    "noice",
                    "flash_prompt",
                    "NeogitStatus",
                    function(win)
                        -- exclude non-focusable windows
                        return not vim.api.nvim_win_get_config(win).focusable
                    end,
                },
            },
            label = {
                rainbow = {
                    enabled = true,
                    shade = 7,
                },
            },
            modes = {
                search = {
                    enabled = true
                },
                char = {
                    jump_labels = true,
                }
            }
        },
        -- stylua: ignore
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    }
}
