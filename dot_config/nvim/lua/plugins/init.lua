-- All plugins in one big file for now, so I don't get false impressions
-- about the size, or waste time thinking about how they are laid out
local icons = require('config.icons')
return {
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup({
        filter = "spectrum",
        background_clear = {
          "notify",
          "telescope",
          "which-key",
        },
        plugins = {
          notify = {}
        },
        override = function(c)
          return {
            SnacksPickerDir = { fg = c.base.dimmed3 },
            SnacksDashboardDir = { fg = c.base.dimmed3 }
          }
        end
      })
      vim.cmd([[colorscheme monokai-pro]])
    end,
    lazy = false,
    priority = 1000,
  },
  {
    'nvim-tree/nvim-web-devicons',
    opts = { default = true },
  },
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({
      })
    end
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help' } },
    keys = {
      { '<leader>qs', function() require('persistence').load() end,                desc = 'Restore Session' },
      { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore Last Session' },
      {
        '<leader>qd',
        function() require('persistence').stop() end,
        desc =
        'Don\'t Save Current Session'
      },
    },
  },
  {
    'stevearc/oil.nvim',
    opts = { keymaps = {} },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function(_, opts)
      local detail = false
      opts.keymaps["<localleader>d"] = {
        desc = "Toggle file detail view",
        callback = function()
          detail = not detail
          if detail then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      }
      require("oil").setup(opts)
    end,
    keys = {
      { '-', '<cmd>Oil<CR>', desc = 'Run oil in current buffer dir' }
    },
    event = 'VeryLazy'
  },
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup({
      });
    end,
    keys = {
      { '<leader>S', '<cmd>lua require(\'grug-far\').open()<CR>', desc = 'Open grug-far' }
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      search = {
        mode = 'fuzzy',
        exclude = {
          'cmp_menu',
          'noice',
          'flash_prompt',
          'NeogitStatus',
          function(win)
            -- exclude non-focusable windows
            return not vim.api.nvim_win_get_config(win).focusable
          end,
        },
      },
      label = {
        rainbow = {
          enabled = true,
          shade = 7,
        },
      },
      modes = {
        search = {
          enabled = true
        },
        char = {
          jump_labels = true,
        }
      }
    },
    -- stylua: ignore
    keys = {
      { 's',     mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,              desc = 'Flash' },
      { 'S',     mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end,        desc = 'Flash Treesitter' },
      { 'r',     mode = 'o',               function() require('flash').remote() end,            desc = 'Remote Flash' },
      { 'R',     mode = { 'o', 'x' },      function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' },           function() require('flash').toggle() end,            desc = 'Toggle Flash Search' },
    },
  },
  -- Makes improvements to the web motions, brings consistency too.
  {
    'chrisgrieser/nvim-spider',
    keys = {
      { 'w', '<cmd>lua require(\'spider\').motion(\'w\')<CR>', mode = { 'n', 'o', 'x' } },
      { 'e', '<cmd>lua require(\'spider\').motion(\'e\')<CR>', mode = { 'n', 'o', 'x' } },
      { 'b', '<cmd>lua require(\'spider\').motion(\'b\')<CR>', mode = { 'n', 'o', 'x' } },
    },
    config = function(_, opts)
      require('spider').setup(opts)
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = true
  },
  -- This is taken almost as-writ from
  -- https://alpha2phi.medium.com/modern-neovim-init-lua-ab1220e3ecc1
  -- https://github.com/alpha2phi/modern-neovim/blob/main/lua/plugins/treesitter/init.lua
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    event = 'BufReadPost',
    config = function()
      require('nvim-treesitter.configs').setup {
        modules = {},
        ensure_installed = 'all',
        sync_install = false,
        auto_install = true,
        ignore_install = { 'ipkg' },
        highlight = { enable = true },
        indent = { enable = false },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
          },
        },
      }
    end,
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.config
    ---@diagnostic disable-next-line:missing-fields
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", cwd = true, indent = 2, padding = 1 },
          { section = "startup" },
        },
        keys = {
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = { enabled = true, formatters = { file = { filename_first = true, truncate = 80 } } },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        ---@diagnostic disable-next-line:missing-fields
        notification = {
          wo = { wrap = true }
        }
      }
    },
    keys = {
      -- Top Pickers & Explorer
      { '<leader><space>', function() Snacks.picker.smart() end,                  desc = 'Smart Find Files' },
      { '<leader>,',       function() Snacks.picker.buffers() end,                desc = 'Buffers' },
      { '<C-p>',           function() Snacks.picker.files({ hidden = true }) end, desc = 'Find Files' },
      { '<C-f>',           function() Snacks.picker.grep() end,                   desc = 'Grep' },
      { '<leader>fg',      function() Snacks.picker.git_files() end,              desc = 'Find Git Files' },
      { '<leader>n',       function() Snacks.picker.notifications() end,          desc = 'Notification History' },
      { '<leader>e',       function() Snacks.explorer() end,                      desc = 'File Explorer' },
      { '<leader>sw',      function() Snacks.picker.grep_word() end,              desc = 'Visual selection or word', mode = { 'n', 'x' } },
      { '<C-s>',           function() Snacks.picker.git_branches() end,           desc = 'Git Branches' },
      -- search
      { '<leader>s"',      function() Snacks.picker.registers() end,              desc = 'Registers' },
      { '<leader>sa',      function() Snacks.picker.autocmds() end,               desc = 'Autocmds' },
      { '<leader>sb',      function() Snacks.picker.lines() end,                  desc = 'Buffer Lines' },
      { '<leader>sc',      function() Snacks.picker.command_history() end,        desc = 'Command History' },
      { '<leader>sC',      function() Snacks.picker.commands() end,               desc = 'Commands' },
      { '<leader>sd',      function() Snacks.picker.diagnostics() end,            desc = 'Diagnostics' },
      { '<leader>sD',      function() Snacks.picker.diagnostics_buffer() end,     desc = 'Buffer Diagnostics' },
      { '<leader>sh',      function() Snacks.picker.help() end,                   desc = 'Help Pages' },
      { '<leader>sk',      function() Snacks.picker.keymaps() end,                desc = 'Keymaps' },
      { '<leader>sq',      function() Snacks.picker.qflist() end,                 desc = 'Quickfix List' },
      { '<leader>se',      function() Snacks.picker.icons() end,                  desc = 'Quickfix List' },
      -- LSP
      { 'gd',              function() Snacks.picker.lsp_definitions() end,        desc = 'Goto Definition' },
      { 'gD',              function() Snacks.picker.lsp_declarations() end,       desc = 'Goto Declaration' },
      { 'gr',              function() Snacks.picker.lsp_references() end,         nowait = true,                     desc = 'References' },
      { 'gI',              function() Snacks.picker.lsp_implementations() end,    desc = 'Goto Implementation' },
      { 'gy',              function() Snacks.picker.lsp_type_definitions() end,   desc = 'Goto T[y]pe Definition' },
      { '<leader>ss',      function() Snacks.picker.lsp_symbols() end,            desc = 'LSP Symbols' },
      { '<leader>sS',      function() Snacks.picker.lsp_workspace_symbols() end,  desc = 'LSP Workspace Symbols' },
      -- Other
      { '<leader>cR',      function() Snacks.rename.rename_file() end,            desc = 'Rename File' },
      { '<leader>un',      function() Snacks.notifier.hide() end,                 desc = 'Dismiss All Notifications' },
      { '<c-/>',           function() Snacks.terminal() end,                      desc = 'Toggle Terminal' },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          Snacks.toggle({
            name = "Conform format-on-save",
            get = function()
              return vim.g.conform_format_on_save
            end,
            set = function(state)
              vim.g.conform_format_on_save = state and true or false
            end,
          }):map("<leader>uf")
          Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
          Snacks.toggle.diagnostics():map('<leader>ud')
          Snacks.toggle.inlay_hints():map('<leader>uh')
          Snacks.toggle.indent():map('<leader>ug')
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })
      -- Taken from the snacks debug page
      _G.dd = function(...)
        Snacks.debug.inspect(...)
      end
      _G.bt = function()
        Snacks.debug.backtrace()
      end
      vim.print = _G.dd
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      { '<leader>cn', '<cmd>ConformInfo<cr>', desc = 'Conform Info' },
    },
    opts = {
      -- TODO: Pull into language files
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        go = { "gofumpt" }
      },
      formatters = {
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
    },
    init = function()
      vim.o.formatexpr = 'v:lua.require\'conform\'.formatexpr()'
    end,
    config = function(_, opts)
      require('conform').setup(opts)
      vim.g.conform_format_on_save = true
      -- We supply our own on-save command so that it obeys vim.g.conform_format_on_save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          if vim.g.conform_format_on_save then
            require("conform").format({ bufnr = args.buf })
          end
        end,
      })
    end
  },
  {
    "stevearc/overseer.nvim",
    keys = {
      { "<leader>oR", "<cmd>OverseerRunCmd<cr>",       desc = "Run Command" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>",   desc = "Task Action" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>",        desc = "Build" },
      { "<leader>od", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
      { "<leader>ol", "<cmd>OverseerLoadBundle<cr>",   desc = "Load Bundle" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>",  desc = "Quick Action" },
      { "<leader>or", "<cmd>OverseerRun<cr>",          desc = "Run" },
      { "<leader>os", "<cmd>OverseerSaveBundle<cr>",   desc = "Save Bundle" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>",       desc = "Toggle" },
    },
    lazy = false,
    opts = {
      templates = { "builtin", "git", "mise" }
    },
    config = function(_, opts)
      local overseer = require('overseer')
      overseer.setup(opts)
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    dependencies = {
      {
        'folke/snacks.nvim',
        opts = function(_, opts)
          return vim.tbl_deep_extend('force', opts or {}, {
            picker = {
              actions = require('trouble.sources.snacks').actions,
              win = {
                input = { keys = { ['<C-x>'] = { 'trouble_open', mode = { 'n', 'i' } } } },
              },
            },
          })
        end,
      },
    },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle pinned=true win.relative=win win.position=right<cr>",
        desc = "Toggle document symbols"
      },
      {
        "<leader>xw",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Workspace diagnostics"
      },
      {
        "<leader>xd",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Document diagnostics"
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Loccation List",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List",
      },
      {
        "<leader>xt",
        "<cmd>Trouble snacks toggle<cr>",
        desc = "Snacks Results",
      },
      {
        "<leader>xf",
        "<cmd>Trouble snacks_files toggle<cr>",
        desc = "Snacks Files Results",
      },
      {
        "]x",
        --- @diagnostic disable-next-line:missing-parameter,missing-fields
        function() require("trouble").next({ skip_groups = true, jump = true }) end,
        desc = "Next Trouble Item"
      },
      {
        "[x",
        --- @diagnostic disable-next-line:missing-parameter,missing-fields
        function() require("trouble").prev({ skip_groups = true, jump = true }) end,
        desc = "Previous Trouble Item"
      }

    }
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "folke/snacks.nvim"
    },
    config = true,
    keys = {
      {
        "<leader>gg",
        function()
          local ng = require('neogit')
          ng.open({ kind = "floating" })
        end,
        desc = "Open Neogit"
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs                        = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
      linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir                 = {
        follow_files = true
      },
      auto_attach                  = true,
      attach_to_untracked          = false,
      current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority                = 6,
      update_debounce              = 100,
      status_formatter             = nil,   -- Use default
      max_file_length              = 40000, -- Disable if file is longer than this (in lines)
      preview_config               = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      on_attach                    = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
        map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" })
        map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" })
        map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })
        map("n", "<leader>ghb", function()
          gs.blame_line { full = true }
        end, { desc = "Blame Line" })
        map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
        map("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })
        map("n", "<leader>ghd", function()
          gs.diffthis "~"
        end, { desc = "Diff This ~" })
        map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle Delete" })
        map("n", "<leader>gb", gs.blame, { desc = "Blame buffer" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
      end,
    },
  },
  {
    "almo7aya/openingh.nvim",
    keys = {
      {
        "<leader>go",
        ":OpenInGHFile <CR>",
        desc = "Open File in GH"
      },
      {
        "<leader>go",
        ":OpenInGHFileLines <CR>",
        mode = "v",
        desc = "Open lines in GH"
      }
    },
  },
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
          {
            "honza/vim-snippets",
            config = function()
              require("luasnip.loaders.from_snipmate").lazy_load()

              -- One peculiarity of honza/vim-snippets is that the file with the global snippets is _.snippets, so global snippets
              -- are stored in `ls.snippets._`.
              -- We need to tell luasnip that "_" contains global snippets:
              require("luasnip").filetype_extend("all", { "_" })
            end,
          },
        },
      },
      'Kaiser-Yang/blink-cmp-git',
      "mikavilpas/blink-ripgrep.nvim",
    },
    --- @type blink.cmp.ConfigStrict
    --- @diagnostic disable-next-line
    opts = {
      keymap = { preset = "enter" },
      --- @diagnostic disable-next-line
      completion = {
        keyword = { range = "full" },
        --- @diagnostic disable-next-line
        documentation = {
          auto_show = true,
        },
        --- @diagnostic disable-next-line
        ghost_text = { enabled = true }
      },
      -- Experimental signature help support
      --- @diagnostic disable-next-line
      signature = {
        enabled = true
      },
      --- @diagnostic disable-next-line
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        nerd_font_variant = "mono",
      },
      --- @diagnostic disable-next-line
      snippets = { preset = "luasnip" },
      --- @diagnostic disable-next-line
      sources = {
        default = { "lsp", "snippets", "path", "ripgrep", "git" },
        per_filetype = {
          lua = { inherit_defaults = true, 'lazydev' },
          gitcommit = { 'snippets', 'git' }
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
          git = {
            module = 'blink-cmp-git',
            name = 'Git',
            opts = { commit = { triggers = { '¬' } } }
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            score_offset = -50
          }
        }
      },
      -- Disable cmdline completions
      --- @diagnostic disable-next-line
      cmdline = {
        enabled = false,
      },
    },
    -- without having to redefine it
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat", -- Support nvim-cmp source
      "sources.default",
    },
  },
  {
    "danymat/neogen",
    opts = function()
      local langs = require('languages')
      local neogenLangs = {}
      for lang, config in pairs(langs) do
        if config.neogen ~= nil then
          neogenLangs[lang] = config.neogen
        end
      end
      return {
        snippet_engine = "luasnip",
        enabled = true,
        languages = neogenLangs,
      }
    end,
    keys = {
      { "<leader>lgd", function() require("neogen").generate({}) end,                desc = "Annotation", },
      { "<leader>lgc", function() require("neogen").generate { type = "class" } end, desc = "Class", },
      { "<leader>lgf", function() require("neogen").generate { type = "func" } end,  desc = "Function", },
      { "<leader>lgt", function() require("neogen").generate { type = "type" } end,  desc = "Type", },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "meuter/lualine-so-fancy.nvim",
      "SmiteshP/nvim-navic",
    },
    event = "VeryLazy",
    opts = function()
      -- Components
      local function code_location()
        local navic = require('nvim-navic')
        if navic.is_available() then
          local location = navic.get_location()
          local nice_location = ""
          if location ~= nil and location ~= "" then
            nice_location = "%#WinBarContext#" .. icons.ui.ChevronRight .. " " .. location .. " %*"
          end
          return nice_location
        else
          return ""
        end
      end
      local diff = {
        "diff",
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      }
      local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        diagnostics_color = {
          error = "DiagnosticError",
          warn = "DiagnosticWarn",
          info = "DiagnosticInfo",
          hint = "DiagnosticHint",
        },
        colored = true,
      }

      return {
        options = {
          icons_enabled = true,
          theme = "monokai-pro",
          component_separators = {},
          section_separators = {},
          disabled_filetypes = {
            statusline = { "lazy", "" },
            winbar = {
              "help",
              "lazy",
              "dap-view",
              "dap-repl"
            },
          },
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = { { "fancy_mode", width = 3 }, "encoding" },
          lualine_b = {
            { "fancy_cwd", substitute_home = true } },
          lualine_c = { "branch" },
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "location" },
        },
        extensions = { "toggleterm", "quickfix" },
        winbar = {
          lualine_a = { { "filename", path = 1 } },
          lualine_b = { code_location },
          lualine_c = {},
          lualine_x = { "lsp_status", diagnostics },
          lualine_y = { diff },
          lualine_z = { "filetype", },
        },
        inactive_winbar = {
          lualine_a = { { "filename", path = 1 }, },
          lualine_b = {},
          lualine_c = {},
          lualine_x = { diagnostics },
          lualine_y = { diff },
          lualine_z = { "filetype" },
        },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      -- I think snacks integration is currently "not quite released".
      -- The code works, but todo_comments is apparently not defined
      -- 乁_(ツ)_ㄏ
      ---@diagnostic disable-next-line:undefined-field
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    }
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim",        words = { "Snacks" } },
        { path = "lazy.nvim",          words = { "LazyVim" } },
        { path = "blink.cmp",          words = { "blink" } },
      },
    },
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      -- Not sure the nicest way to do this, but for the moment I'm going to
      -- just bosh it in here.
      -- TODO: Pull into language blocks
      local lint = require("lint")

      -- Action lint
      local actionlint = lint.linters.actionlint
      actionlint.stdin = false
      actionlint.args = { '-format', '{{json .}}' }

      -- Golangcilint has error code nonsense
      lint.linters.golangcilint.ignore_exitcode = true
      -- General setups
      lint.linters_by_ft = {
        ['yaml.gha'] = { 'actionlint' },
        go = { 'golangcilint' }
      }

      vim.api.nvim_create_autocmd('BufWritePost', {
        group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
        pattern = '*',
        callback = function()
          lint.try_lint()
        end,
      })
    end,
    event = "BufReadPost"
  },
  { "b0o/schemastore.nvim" },
  {
    "qvalentin/helm-ls.nvim",
    ft = "helm"
  },
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<localleader>dR", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
      {
        "<localleader>dE",
        function() require("dapui").eval(vim.fn.input "[Expression] > ") end,
        desc =
        "Evaluate Input",
      },
      {
        "<localleader>dB",
        function() require("dap").toggle_breakpoint() end,
        desc =
        "Toggle Breakpoint",
      },
      {
        "<localleader>dC",
        function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end,
        desc =
        "Conditional Breakpoint",
      },
      {
        "<localleader>dU",
        function() require("dap-view").toggle() end,
        desc =
        "Toggle UI",
      },
      {
        "<localleader>db",
        function() require("dap").step_back() end,
        desc =
        "Step Back",
      },
      {
        "<localleader>dc",
        function() require("dap").continue() end,
        desc =
        "Continue",
      },
      {
        "<localleader>dd",
        function() require("dap").disconnect() end,
        desc =
        "Disconnect",
      },
      {
        "<localleader>dg",
        function() require("dap").session() end,
        desc =
        "Get Session",
      },
      {
        "<localleader>di",
        function() require("dap").step_into() end,
        desc =
        "Step Into",
      },
      {
        "<localleader>do",
        function() require("dap").step_over() end,
        desc =
        "Step Over",
      },
      {
        "<localleader>dl",
        function() require("dap").run_last() end,
        desc =
        "Run Last"
      },
      { "<localleader>dp", function() require("dap").pause.toggle() end,  desc = "Pause", },
      { "<localleader>dq", function() require("dap").close() end,         desc = "Quit", },
      {
        "<localleader>dr",
        function() require("dap").repl.toggle() end,
        desc =
        "Toggle REPL",
      },
      {
        "<localleader>ds",
        function()
          require("dap").continue()
        end,
        desc = "Start",
      },
      {
        "<localleader>dx",
        function() require("dap").terminate() end,
        desc =
        "Terminate",
      },
      {
        "<localleader>du",
        function() require("dap").step_out() end,
        desc =
        "Step Out",
      },
    },
    event = "BufReadPre"
  },
  {
    "leoluz/nvim-dap-go",
    dependencies = {
      "mfussenegger/nvim-dap"
    },
    config = function()
      require('dap-go').setup()
    end
  },
  {
    "igorlfs/nvim-dap-view",
    dependencies = {
      "mfussenegger/nvim-dap"
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "fredrikaverpil/neotest-golang",
    },
    keys = {
      {
        '<leader>ts',
        function() require('neotest').summary.toggle() end,
        desc = "Toggle Neotest Summary"
      },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand("%")) end, desc = "Test current file" },
      { '<leader>tr', function() require('neotest').run.run() end,                   desc = "Run test" },
      { '<leader>to', function() require('neotest').output.open() end,               desc = "Open Test Output" },
      {
        "<leader>tD",
        function() require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' }) end,
        desc = "Debug File"
      },
      {
        "<leader>td",
        function() require('neotest').run.run({ strategy = 'dap' }) end,
        desc = "Debug test"
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python"),
          require("neotest-golang")
        }
      })
    end
  },
}
