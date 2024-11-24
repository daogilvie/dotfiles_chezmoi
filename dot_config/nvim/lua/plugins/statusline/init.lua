local icons = require('config.icons')
local function code_location()
    local navic = require('nvim-navic')
    if navic.is_available() then
        local location = navic.get_location()
        local nice_location = ""
        if location ~= nil and location ~= "" then
            nice_location = "%#WinBarContext#" .. icons.ui.ChevronRight .. " " .. location .. " %*"
        end
        return nice_location
    else
        return ""
    end
end
return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "meuter/lualine-so-fancy.nvim",
            "SmiteshP/nvim-navic",
        },
        event = "VeryLazy",
        opts = function()
            local components = require "plugins.statusline.components"
            return {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = {},
                    section_separators = {},
                    disabled_filetypes = {
                        statusline = { "alpha", "lazy", "fugitive", "" },
                        winbar = {
                            "help",
                            "alpha",
                            "fugitive",
                            "lazy",
                            "dapui_console",
                            "dap-repl"
                        },
                    },
                    always_divide_middle = true,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { { "fancy_mode", width = 3 } },
                    lualine_b = {
                        { "fancy_cwd", substitute_home = true },
                        components.git_repo, "branch" },
                    lualine_c = {
                        "fancy_lsp_servers"
                    },
                    lualine_x = { components.spaces, "encoding", },
                    lualine_y = {},
                    lualine_z = {},
                },
                extensions = { "toggleterm", "quickfix" },
                winbar = {
                    lualine_a = { { "filename", path = 1 }, code_location },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = { components.diagnostics },
                    lualine_y = {
                        components.diff,
                    },
                    lualine_z = { "filetype", },
                },
                inactive_winbar = {
                    lualine_a = { { "filename", path = 1 }, },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = { components.diagnostics },
                    lualine_y = {
                        components.diff,
                    },
                    lualine_z = { "filetype" },
                },
            }
        end,
    },
}
