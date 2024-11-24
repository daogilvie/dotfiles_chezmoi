return {
  name = "Create GH PR",
  builder = function()
    return {
      cmd = { "gh" },
      args = { "pr", "create", "-w" },
      components = { { "on_complete_dispose", timeout = 10 }, "default" },
    }
  end,
  condition = {
    -- Only offer this task in a git repo
    -- Does assume that all git repos are GH, but that's
    -- currently mostly true for me.
    callback = function(_)
      local path = vim.loop.cwd() .. "/.git"
      local ok, _ = vim.loop.fs_stat(path)
      return true
    end
  }
}
