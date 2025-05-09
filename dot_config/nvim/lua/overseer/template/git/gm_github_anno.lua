local utils = require("utils")

return {
  name = "Git Machete Anno PRs",
  builder = function()
    return {
      cmd = { "git" },
      args = { "machete", "github", "anno-prs" },
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
