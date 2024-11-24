return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    -- Telescope is so fundamental that we always want it
    lazy = false,
    config = function()
      local map = require('utils').map_key
      local tele = require('telescope.builtin')
      local tele_file_browser = require 'telescope'.extensions.file_browser.file_browser
      local trouble = require("trouble.providers.telescope")
      local trouble_tele_source = require("trouble.sources.telescope")
      local function tele_find_with_hidden()
        local opts = { hidden = true }
        return tele.find_files(opts)
      end
      local function tele_grep_with_hidden()
        local opts = { additional_args = { "--hidden" } }
        return tele.live_grep(opts)
      end

      -- Telescope keymaps

      map({ 'n' }, '<C-f>', tele_grep_with_hidden, 'Live Grep (inc hidden)')
      map({ 'n' }, '<C-p>', tele_find_with_hidden, 'Find file (inc hidden)')
      map({ 'n' }, '<C-s>', tele.git_branches, 'Git branches')
      map({ 'n' }, '<C-c>', tele.git_commits, 'Git branches')
      map({ 'n' }, '<leader>o', tele_file_browser, 'File Browser')
      map({ 'n' }, '<leader>O', function()
        tele_file_browser({ path = '%:p:h', cwd_to_path = true })
      end, 'File Browser open at buffer')
      map({ 'n' }, '<leader>se', tele.symbols, 'Search emoji')
      map({ 'n' }, '<leader>sp', tele.buffers, 'Search buffers')
      map({ 'n' }, '<leader>sw', function()
        tele.grep_string({ search = vim.fn.expand('<cword>') })
      end, 'Search CWord')
      map({ 'n' }, '<leader>sR', tele.lsp_dynamic_workspace_symbols, 'Workspace symbols')
      map({ 'n' }, '<leader>sr', tele.lsp_document_symbols, 'Document symbols')

      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      local fb_actions = require "telescope".extensions.file_browser.actions

      local custom_actions = {}

      -- multi-select enabled cleverness
      -- similar to fzf.
      -- Adapted from https://github.com/nvim-telescope/telescope.nvim/issues/416#issuecomment-841273053
      -- Possible entry-point to learning lua and contrib?
      -- Adapted to do cwd on filebrowser
      function custom_actions.fzf_multi_select(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local num_selections = #(picker:get_multi_selection())

        if num_selections > 1 then
          trouble_tele_source.open(prompt_bufnr)
        else
          actions.select_default(prompt_bufnr)
        end
      end

      require('telescope').setup {
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
          },
          prompt_prefix = '> ',
          selection_caret = '> ',
          entry_prefix = ' ',
          initial_mode = 'insert',
          selection_strategy = 'reset',
          sorting_strategy = 'descending',
          layout_strategy = 'vertical',
          layout_config = {
            width = 0.90,
            height = 0.90,
            prompt_position = 'bottom',
          },
          file_sorter = require 'telescope.sorters'.get_fuzzy_file,
          file_ignore_patterns = {},
          generic_sorter = require 'telescope.sorters'.get_generic_fuzzy_sorter,
          path_display = {
            "filename_first"
          },
          winblend = 0,
          border = {},
          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          color_devicons = true,
          use_less = true,
          set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
          file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
          grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
          qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
          mappings = {
            i = {
              ['<C-q>'] = actions.send_to_qflist,
              ['<tab>'] = actions.toggle_selection,
              ['<s-tab>'] = actions.toggle_selection,
              ['<cr>'] = custom_actions.fzf_multi_select
            },
            n = {
              ['<C-q>'] = actions.send_to_qflist,
              ['<tab>'] = actions.toggle_selection,
              ['<s-tab>'] = actions.toggle_selection,
              ['<cr>'] = custom_actions.fzf_multi_select
            },
          }
        },
        extensions = {
          file_browser = {
            mappings = {
              i = {
                ['<C-r>'] = fb_actions.rename,
                ['<C-y>'] = fb_actions.copy,
                ['<C-m>'] = fb_actions.move,
                ['<C-d>'] = fb_actions.remove,
                ['<C-n>'] = fb_actions.create_from_prompt,
              },
            }
          },
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          }
        }
      }
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('file_browser')
    end
  },
  { 'nvim-telescope/telescope-fzf-native.nvim',   build = 'make', lazy = false },
  { 'nvim-telescope/telescope-file-browser.nvim', lazy = false },
  { 'nvim-telescope/telescope-symbols.nvim',      lazy = false },
}
