local utils = require('custom.utils')

local function custom_previewer_maker(filepath, bufnr, opts)
  if utils.is_large_file(filepath) then
    return
  end

  require('telescope.previewers').buffer_previewer_maker(filepath, bufnr, opts)
end

return {
  'nvim-telescope/telescope.nvim',

  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'tpope/vim-fugitive' },
  },

  cmd = 'Telescope',
  keys = {
    { 'gd',         function() require('telescope.builtin').lsp_definitions() end,                   mode = { 'n' } },
    { 'gr',         function() require('telescope.builtin').lsp_references() end,                    mode = { 'n' } },
    { 'gi',         function() require('telescope.builtin').lsp_implementations() end,               mode = { 'n' } },
    { 'go',         function() require('telescope.builtin').lsp_type_definitions() end,              mode = { 'n' } },

    { '<leader>fp', function() require('telescope.builtin').resume() end,                            mode = { 'n', 'v' } },
    { '<C-f>',      function() require('telescope.builtin').find_files({ previewer = false }) end,   mode = { 'n', 'v' } },
    { '<leader>fb', function() require('telescope.builtin').buffers({ previewer = false }) end,      mode = { 'n', 'v' } },
    { '<leader>fh', function() require('telescope.builtin').help_tags({ previewer = false }) end,    mode = { 'n', 'v' } },
    { '<leader>fd', function() require('telescope.builtin').diagnostics({ previewer = false }) end,  mode = { 'n', 'v' } },
    { '<leader>fr', function() require('telescope.builtin').live_grep({ previewer = false }) end,    mode = { 'n', 'v' } },
    { '<leader>fp', function() require('telescope.builtin').commands({ previewer = false }) end,     mode = { 'n', 'v' } },

    { '<leader>fg', function() require('telescope.builtin').git_branches({ previewer = false }) end, mode = { 'n', 'v' } },
    { '<leader>fc', function() require('telescope.builtin').git_commits({ previewer = false }) end,  mode = { 'n', 'v' } },
    { '<leader>fC', function() require('telescope.builtin').git_bcommits({ previewer = false }) end, mode = { 'n', 'v' } },
    { '<leader>ff', 
      function() 
        require('telescope.builtin').find_files({ 
          find_command = { 'fd', '--strip-cwd-prefix'}, 
          previewer = false
        }) 
      end, 
      mode = { 'n', 'v'} 
    },
    {
      '<leader>fs',
      function()
        vim.ui.input({ prompt = 'grep > ' }, function(value)
          if value == '' then
            return
          end

          require('telescope.builtin').grep_string({ search = value })
        end)
      end,
      mode = { 'n' }
    },
    { '<leader>fs', function() require('telescope.builtin').grep_string({ search = utils.get_visual_selection() }) end, mode = { 'v' } },
  },

  opts = {
    defaults = {
      buffer_previewer_maker = custom_previewer_maker,
    },
    pickers = {
      find_files = {
        find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix'}
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
      },
    },
  },

  config = function(_, opts)
    local telescope = require('telescope')
    telescope.setup(opts)

    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')
  end,
}
