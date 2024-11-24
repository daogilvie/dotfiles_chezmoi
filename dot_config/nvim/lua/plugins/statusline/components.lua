local icons = require "config.icons"
local Job = require "plenary.job"

return {
    spaces = {
        function()
            local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
            return icons.ui.Tab .. " " .. shiftwidth
        end,
        padding = 1,
    },
    git_repo = {
        function()
            local results = {}
            local job = Job:new {
                command = "git",
                args = { "rev-parse", "--show-toplevel" },
                cwd = vim.fn.expand "%:p:h",
                on_stdout = function(_, line)
                    table.insert(results, line)
                end,
            }
            job:sync()
            if results[1] ~= nil then
                return vim.fn.fnamemodify(results[1], ":t")
            else
                return ""
            end
        end,
    },
    diff = {
        "diff",
        source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
                return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                }
            end
        end,
    },
    diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        diagnostics_color = {
            error = "DiagnosticError",
            warn = "DiagnosticWarn",
            info = "DiagnosticInfo",
            hint = "DiagnosticHint",
        },
        colored = true,
    },
}
