return {
    name = "Git Machete Traverse All",
    builder = function()
        return {
            cmd = { "git" },
            args = { "machete", "traverse", "-W", "-y" },
            components = { { "open_output", direction = "vertical" }, { "on_complete_dispose", timeout = 10 }, "default" },
        }
    end,
    condition = {
        -- Only offer this task in a git repo
        -- Does assume that all git repos are GH, but that's
        -- currently mostly true for me.
        callback = function(search)
            local path = vim.loop.cwd() .. "/.git"
            local ok, _ = vim.loop.fs_stat(path)
            return true
        end
    }
}
