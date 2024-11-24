return {
    name = "Git Machete Anno",
    builder = function()
        return {
            cmd = { "git" },
            args = { "machete", "github", "anno-prs" },
            components = { { "on_complete_dispose", timeout = 10 }, "default" },
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
