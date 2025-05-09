local utils = require("utils")

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
      return utils.can_exec("git-machete") and utils.is_git_repo()
    end
  }
}
