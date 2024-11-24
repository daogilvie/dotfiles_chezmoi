-- This is taken almost as-writ from
-- https://alpha2phi.medium.com/modern-neovim-init-lua-ab1220e3ecc1
-- https://github.com/alpha2phi/modern-neovim/blob/main/lua/plugins/treesitter/init.lua
return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        build = ":TSUpdate",
        event = "BufReadPost",
        config = function()
            local swap_next, swap_prev = (function()
                local swap_objects = {
                    p = "@parameter.inner",
                    f = "@function.outer",
                    c = "@class.outer",
                }

                local n, p = {}, {}
                for key, obj in pairs(swap_objects) do
                    n[string.format("<leader>cx%s", key)] = obj
                    p[string.format("<leader>cX%s", key)] = obj
                end

                return n, p
            end)()

            require("nvim-treesitter.configs").setup {
                ensure_installed = 'all',
                highlight = { enable = true },
                indent = { enable = false },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = swap_next,
                        swap_previous = swap_prev,
                    },
                    lsp_interop = {
                        enable = true,
                        border = 'none',
                        peek_definition_code = {
                            ["<leader>pf"] = "@function.outer",
                            ["<leader>pF"] = "@class.outer",
                        },
                    },
                },
            }
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local npairs = require "nvim-autopairs"
            npairs.setup {
                check_ts = true,
            }
        end,
    },
    {
        "ckolkey/ts-node-action",
        dependencies = { "nvim-treesitter" },
        enabled = true,
        opts = {},
        keys = {
            {
                "<leader>ln",
                function()
                    require("ts-node-action").node_action()
                end,
                desc = "Node Action",
            },
        },
    },
}
