-- Largely inspired by tiny.nvim setup
local M = {}

function M.diagnostic_goto(next, severity)
  local count = next and 1 or -1
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { count = count, float = true, severity = severity }
  end
end

M.get_default_keymaps = function()
  return {
    { keys = "K",  func = vim.lsp.buf.hover,                   desc = "Documentation",   has = "hoverProvider" },
    { keys = "gd", func = vim.lsp.buf.definition,              desc = "Goto Definition", has = "definitionProvider" },
    { keys = "]d", func = M.diagnostic_goto(true),             desc = "Next Diagnostic" },
    { keys = "[d", func = M.diagnostic_goto(false),            desc = "Prev Diagnostic" },
    { keys = "]e", func = M.diagnostic_goto(true, "ERROR"),    desc = "Next Error" },
    { keys = "[e", func = M.diagnostic_goto(false, "ERROR"),   desc = "Prev Error" },
    { keys = "]w", func = M.diagnostic_goto(true, "WARNING"),  desc = "Next Warning" },
    { keys = "[w", func = M.diagnostic_goto(false, "WARNING"), desc = "Prev Warning" },
  }
end

M.on_attach = function(client, buffer)
  local navic = require("nvim-navic")
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, buffer)
  end

  local keymaps = M.get_default_keymaps()
  for _, keymap in ipairs(keymaps) do
    if not keymap.has or client.server_capabilities[keymap.has] then
      vim.keymap.set(keymap.mode or "n", keymap.keys, keymap.func, {
        buffer = buffer,
        desc = "LSP: " .. keymap.desc,
        nowait = keymap.nowait,
      })
    end
  end
end

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action {
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      }
    end
  end,
})

return M
