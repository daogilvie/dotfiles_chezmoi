return {
  name = "Git Machete GitHub Sync",
  builder = function()
    return {
      cmd = { "git" },
      args = { "machete", "github", "update-pr-descriptions", "--mine" },
      components = {
        {
          "dependencies",
          task_names = {
            "Git Machete Traverse All",
            "Git Machete Delete Unmanaged",
            "Git Machete Anno PRs"
          },
          sequential = true
        }, { "on_complete_dispose", timeout = 10 }, "default" },
    }
  end,
  condition = {
    -- Only offer this task in a git repo
    callback = function(_)
      local path = vim.loop.cwd() .. "/.git"
      local ok, _ = vim.loop.fs_stat(path)
      if vim.fn.executable("git-machete") == 0 then
        return false, 'Command "git-machete" not found'
      end
      return ok ~= nil
    end
  }
}
