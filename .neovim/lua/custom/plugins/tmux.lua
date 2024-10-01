return {
  'aserowy/tmux.nvim',

  keys = {
    { '<C-h>', function() require('tmux').move_left() end,     mode = { 'n', 'v', 'c' } },
    { '<C-l>', function() require('tmux').move_right() end,    mode = { 'n', 'v', 'c' } },
    { '<C-j>', function() require('tmux').move_bottom() end,   mode = { 'n', 'v', 'c' } },
    { '<C-k>', function() require('tmux').move_top() end,      mode = { 'n', 'v', 'c' } },

    { '<A-h>', function() require('tmux').resize_left() end,   mode = { 'n', 'v', 'c' } },
    { '<A-l>', function() require('tmux').resize_right() end,  mode = { 'n', 'v', 'c' } },
    { '<A-j>', function() require('tmux').resize_bottom() end, mode = { 'n', 'v', 'c' } },
    { '<A-k>', function() require('tmux').resize_top() end,    mode = { 'n', 'v', 'c' } },
  },

  opts = {
    navigation = {
      cycle_navigation = false,
      enable_default_keybindings = false,
    },

    resize = {
      enable_default_keybindings = false,
    },
  },
}
