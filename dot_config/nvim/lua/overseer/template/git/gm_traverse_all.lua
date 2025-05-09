local utils = require("utils")

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
    callback = function(_)
      return utils.can_exec("git-machete") and utils.is_git_repo()
    end
  }
}
