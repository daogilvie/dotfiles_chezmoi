local languages = require('languages')

-- LSP configuration
-- TODO: Refer to language files in LSP sections
local lsps = {}
for _, config in pairs(languages) do
  if config.servers ~= nil then
    for lsp_name, lsp_config in pairs(config.servers) do
      -- TODO: handle absence of lsp_exec somehow
      -- We insert into a table to handle de-duplication (e.g js and ts)
      lsps[lsp_name] = lsp_config
    end
  end
end

vim.lsp.enable(vim.tbl_keys(lsps))
