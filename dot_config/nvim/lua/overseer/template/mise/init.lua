-- Originally copied from https://github.com/stevearc/overseer.nvim/pull/414/files
-- but I adapted it for overseer 2.0
local overseer = require("overseer")
local log = require("overseer.log")
-- A make/rake-like build tool using Go
-- https://magefile.org/

---@param opts overseer.SearchParams
---@return nil|string
local function get_mise_file(opts)
  local is_mise_file = function(name)
    name = name:lower()
    return name == "mise.toml" or name == ".mise.toml"
  end
  return vim.fs.find(is_mise_file, { upward = true, path = opts.dir })[1]
end

---@type overseer.TemplateFileProvider
return {
  cache_key = get_mise_file,
  generator = function(opts, cb)
    local cwd = opts.dir
    if vim.fn.executable("mise") == 0 then
      return 'Command "mise" not found'
    end
    if not get_mise_file(opts) then
      return "No mise file found"
    end
    local ret = {}
    overseer.builtin.system(
      { "mise", "tasks", "--json" },
      {
        cwd = opts.dir,
        text = true
      },
      vim.schedule_wrap(function(out)
        if out.code ~= 0 then
          return cb(out.stderr or out.stdout or "Error running 'mise tasks --json'")
        end
        local ok, data =
            pcall(vim.json.decode, out.stdout, { luanil = { object = true } })
        if not ok then
          log:error("mise produced invalid json: %s\n%s", data, out)
          cb(ret)
          return
        end
        assert(data)
        for _, value in pairs(data) do
          table.insert(ret, {
            name = string.format("mise %s", value.name),
            desc = value.description ~= "" and value.description or nil,
            builder = function()
              return {
                cmd = { "mise", "run", value.name },
                cwd = cwd,
              }
            end,
          })
        end
        cb(ret)
      end))
  end
}
