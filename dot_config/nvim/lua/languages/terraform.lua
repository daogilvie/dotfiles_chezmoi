local M = {}

M.servers = function()
    local util = require('lspconfig').util
    return {
        tflint = {},
        terraformls = {}
    }
end

M.modules = {}

M.test_adapters = function()
    return {}
end

return M
