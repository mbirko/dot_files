-- Inspired by and Yanked from [thecodinglab](https://github.com/thecodinglab/neovim-config/blob/master/lua/custom/mappings.lua)
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
  -- clone lazy if not already exists
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
  return
end

lazy.setup({
  require('custom.plugins.theme'),
  require('custom.plugins.tmux'),
  require('custom.plugins.treesitter'),
  require('custom.plugins.hardtime'),
  require('custom.plugins.lualine'),

  require('custom.plugins.telescope'),
  require('custom.plugins.lsp'),
  require('custom.plugins.fsharp'),
  require('custom.plugins.cmp'),
  require('custom.plugins.snippets'),
  require('custom.plugins.indent-blankline')
}, {
  defaults = { lazy = true, },
  performance = {
    rtp = {
      reset = false,
    },
  },
})
