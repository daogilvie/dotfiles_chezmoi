local languages = require('languages')

-- LSP configuration
local lsps = {}
for lang, config in pairs(languages) do
  for lsp_name, lsp_exec in pairs(config.servers) do
    -- TODO: handle absence of lsp_exec somehow
    table.insert(lsps, lsp_name)
  end
end

vim.lsp.enable(lsps)
