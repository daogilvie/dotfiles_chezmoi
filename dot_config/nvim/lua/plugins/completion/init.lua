-- This is adapted from alpha2phi
-- https://github.com/alpha2phi/modern-neovim/blob/main/lua/plugins/completion/init.lua
local icons = require('config.icons')
return {
    {
        "danymat/neogen",
        opts = {
            snippet_engine = "luasnip",
            enabled = true,
            languages = {
                lua = {
                    template = {
                        annotation_convention = "ldoc",
                    },
                },
                python = {
                    template = {
                        annotation_convention = "google_docstrings",
                    },
                },
                javascript = {
                    template = {
                        annotation_convention = "jsdoc",
                    },
                },
                typescript = {
                    template = {
                        annotation_convention = "tsdoc",
                    },
                },
                typescriptreact = {
                    template = {
                        annotation_convention = "tsdoc",
                    },
                },
                go = {
                    template = {
                        annotation_convention = "godoc"
                    }
                }
            },
        },
        keys = {
            { "<leader>lgd", function() require("neogen").generate({}) end,                desc = "Annotation", },
            { "<leader>lgc", function() require("neogen").generate { type = "class" } end, desc = "Class", },
            { "<leader>lgf", function() require("neogen").generate { type = "func" } end,  desc = "Function", },
            { "<leader>lgt", function() require("neogen").generate { type = "type" } end,  desc = "Type", },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "petertriho/cmp-git",
        },
        opts = function()
            local cmp = require "cmp"
            local luasnip = require "luasnip"
            local neogen = require "neogen"
            local compare = require "cmp.config.compare"
            local source_names = {
                nvim_lsp = "(LSP)",
                luasnip = "(Snippet)",
                buffer = "(Buffer)",
                path = "(Path)",
            }
            local duplicates = {
                buffer = 1,
                path = 1,
                nvim_lsp = 0,
                luasnip = 1,
            }
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
            end

            return {
                completion = {
                    completeopt = "menu,menuone,noinsert,noselect",
                },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        compare.score,
                        compare.recently_used,
                        compare.offset,
                        compare.exact,
                        compare.kind,
                        compare.sort_text,
                        compare.length,
                        compare.order,
                    },
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.jumpable(1) then
                            luasnip.jump(1)
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif neogen.jumpable() then
                            neogen.jump_next()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s", "c" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        elseif neogen.jumpable(-1) then
                            neogen.jump_prev()
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                        "c",
                    }),
                    ["<CR>"] = cmp.mapping {
                        i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
                        c = function(fallback)
                            if cmp.visible() then
                                cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
                            else
                                fallback()
                            end
                        end,
                    },
                },
                sources = cmp.config.sources {
                    { name = "nvim_lsp", group_index = 1 },
                    { name = "luasnip",  group_index = 1 },
                    { name = "buffer",   group_index = 2 },
                    { name = "path",     group_index = 2 },
                    { name = "git",      group_index = 2 },
                },
                formatting = {
                    format = function(entry, item)
                        local max_width = 80
                        local duplicates_default = 0
                        if max_width ~= 0 and #item.abbr > max_width then
                            item.abbr = string.sub(item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
                        end
                        item.kind = icons.lspkind[item.kind]
                        item.menu = source_names[entry.source.name]
                        item.dup = duplicates[entry.source.name] or duplicates_default

                        return item
                    end,
                },
                window = {
                    documentation = {
                        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
                    },
                },
            }
        end,
        config = function(_, opts)
            local cmp = require "cmp"
            cmp.setup(opts)

            -- In the search and command line, I just want enter to run whatever is typed
            local cr_override = {
                ["<CR>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                    { 'c', 'i' }
                )
            }
            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(cr_override),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(cr_override),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })

            -- Auto pairs
            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

            -- Git
            require("cmp_git").setup { filetypes = { "NeogitCommitMessage" } }
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
            {
                "honza/vim-snippets",
                config = function()
                    require("luasnip.loaders.from_snipmate").lazy_load()

                    -- One peculiarity of honza/vim-snippets is that the file with the global snippets is _.snippets, so global snippets
                    -- are stored in `ls.snippets._`.
                    -- We need to tell luasnip that "_" contains global snippets:
                    require("luasnip").filetype_extend("all", { "_" })
                end,
            },
        },
        build = "make install_jsregexp",
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
        keys = {
            {
                "<C-j>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<C-j>"
                end,
                expr = true,
                remap = true,
                silent = true,
                mode = "i",
            },
            { "<C-j>", function() require("luasnip").jump(1) end,  mode = "s" },
            { "<C-k>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        },
        config = function(_, opts)
            require("luasnip").setup(opts)

            local snippets_folder = vim.fn.stdpath "config" .. "/lua/plugins/completion/snippets/"
            require("luasnip.loaders.from_lua").lazy_load { paths = snippets_folder }

            vim.api.nvim_create_user_command("LuaSnipEdit", function()
                require("luasnip.loaders.from_lua").edit_snippet_files()
            end, {})
        end,
    },
}
