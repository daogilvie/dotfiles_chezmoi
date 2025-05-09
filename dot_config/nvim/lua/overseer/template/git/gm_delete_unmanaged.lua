local utils = require("utils")

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
      return utils.can_exec("git-machete") and utils.is_git_repo()
    end
  }
}
