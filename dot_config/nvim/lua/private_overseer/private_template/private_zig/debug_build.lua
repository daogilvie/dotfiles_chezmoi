return {
  name = "zig build (debug)",
  builder = function()
    return {
      cmd = { "zig" },
      args = { "build", "--summary", "none" },
      components = {
        {
          "on_output_parse",
          parser = {
            diagnostics = {
              { "test",       "^zig build.*: error: *" },
              { "skip_lines", 2 },
              -- Repeat this parsing sequence
              { "loop",
                { "sequence",
                  { "invert",     { "test", ".*/zig/master/lib/std.*" } },
                  { "extract",    "^([^%s].+):(%d+):(%d+): [^%s]+: (.+)$", "filename", "lnum", "cnum", "text" },
                  { "skip_lines", 2 }
                }
              }
            }
          }
        },
        {
          "on_result_diagnostics_quickfix",
        },
        "default" },
    }
  end,
  condition = {
    filetype = { "zig" },
  },
}
