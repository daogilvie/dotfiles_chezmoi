return {
  "anuvyklack/hydra.nvim",
  event = { "VeryLazy" },
  opts = {
    specs = {
    },
  },
  config = function(_, opts)
    local hydra = require "hydra"
    for s, _ in pairs(opts.specs) do
      hydra(opts.specs[s]())
    end
  end,
}
