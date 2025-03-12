-- Taken largely from alpha2phi again
return {
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = function()
            require("diffview").setup({
                keymaps = {
                    file_panel = {
                        { "n", "<leader>cq", "<CMD>DiffviewClose<CR>", { desc = "Close Diffview" } },
                        {
                            "n",
                            "<leader>cF",
                            function()
                                local file_path = require("diffview.lib").get_current_view().panel.cur_file.path
                                local left_commit = require("diffview.lib").get_current_view().left.commit
                                local right_commit = require("diffview.lib").get_current_view().right.commit
                                local cmd = "GIT_EXTERNAL_DIFF='difft --display side-by-side-show-both' git diff "
                                    .. left_commit
                                    .. ":"
                                    .. file_path
                                    .. " "
                                    .. right_commit
                                    .. ":"
                                    .. file_path
                                local popup_buf = vim.api.nvim_create_buf(false, true)
                                local width = vim.o.columns - 6
                                local height = vim.o.lines - 6
                                local win_opts = {
                                    focusable = false,
                                    style = "minimal",
                                    border = "rounded",
                                    relative = "editor",
                                    width = width,
                                    height = height,
                                    anchor = "NW",
                                    row = 3,
                                    col = 3,
                                    noautocmd = true,
                                }
                                local popup_win = vim.api.nvim_open_win(popup_buf, true, win_opts)
                                vim.fn.termopen(cmd)
                            end,
                            { desc = "Diff with difftastic" },
                        },
                    },
                },
            })
        end
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            -- Only one of these is needed.
            "nvim-telescope/telescope.nvim", -- optional
        },
        config = true,
        keys = {
            {
                "<leader>gg",
                function()
                    local ng = require('neogit')
                    ng.open({ kind = "floating" })
                end,
                desc = "Open Neogit"
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            signs                        = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
            numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
            linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir                 = {
                follow_files = true
            },
            auto_attach                  = true,
            attach_to_untracked          = false,
            current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts      = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
            sign_priority                = 6,
            update_debounce              = 100,
            status_formatter             = nil,   -- Use default
            max_file_length              = 40000, -- Disable if file is longer than this (in lines)
            preview_config               = {
                -- Options passed to nvim_open_win
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1
            },
            on_attach                    = function(bufnr)
                local gs = package.loaded.gitsigns
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true })

                -- Actions
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
                map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" })
                map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
                map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" })
                map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })
                map("n", "<leader>ghb", function()
                    gs.blame_line { full = true }
                end, { desc = "Blame Line" })
                map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
                map("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })
                map("n", "<leader>ghd", function()
                    gs.diffthis "~"
                end, { desc = "Diff This ~" })
                map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle Delete" })
                map("n", "<leader>gb", gs.blame, { desc = "Blame buffer" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
            end,
        },
    },
    {
        "almo7aya/openingh.nvim",
        keys = {
            {
                "<leader>go",
                ":OpenInGHFile <CR>",
                desc = "Open File in GH"
            },
            {
                "<leader>go",
                ":OpenInGHFileLines <CR>",
                mode = "v",
                desc = "Open lines in GH"
            }
        },
    }
}
