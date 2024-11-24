local M = {}

M.servers = function()
  return {
    ts_ls = {},
    jsonls = {
      init_options = {
        provideFormatter = false
      }
    }
  }
end

M.modules = {
  {
    'nvim-neotest/neotest-jest',
    dependencies = { 'nvim-neotest/neotest' },
    ft = { "js", "ts" },
  }
}

M.test_adapters = function()
  return {
    require('neotest-jest')({
      env = { CI = true },
      jestConfigFile = function(file)
        if string.find(file, "/packages/") then
          return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
        end

        return vim.fn.getcwd() .. "/jest.config.ts"
      end,
    })
  }
end

return M
