local M = {}

--- Check if we are in a git repo, including sub-dirs
---@return boolean
function M.is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

--- Check if we can find/run executable
---@return boolean
function M.can_exec(cmd)
  return vim.fn.executable(cmd) == 1
end

return M
