local M = {}

M.servers = function()
  return {
    pyright = {},
    ruff = {
      root_dir = require('lspconfig').util.root_pattern('requirements.txt'),
    },
  }
end

M.modules = {
  {
    "mfussenegger/nvim-dap-python",
    ft = { "python", "py" },
    config = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()
      require("dap-python").setup(path .. "/venv/bin/python")
    end
  },
  {
    "nvim-neotest/neotest-python",
    dependencies = { "nvim-neotest/neotest" },
    ft = { "python", "py" },
  }
}

M.test_adapters = function()
  return {
    require("neotest-python")
  }
end
return M
