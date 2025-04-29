return {
  name = "Git Machete Delete Unmanaged",
  builder = function()
    return {
      cmd = { "git" },
      args = { "machete", "delete-unmanaged", "-y" },
      components = { { "on_complete_dispose", timeout = 10 }, "default" },
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
