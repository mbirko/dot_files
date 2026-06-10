-- Inspired by and Yanked from [thecodinglab](https://github.com/thecodinglab/neovim-config/blob/master/lua/custom/options.lua)

-- encoding
vim.opt.fileencoding = 'utf-8'
vim.opt.spelllang = 'en'

-- line handling
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 999
vim.opt.sidescrolloff = 8
vim.opt.wrap = false

vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number';

-- file backups
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true

-- indents
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- netrw
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0

-- clipboard support
vim.opt.clipboard = 'unnamedplus'

-- other

vim.opt.showmode = false
vim.opt.termguicolors = false
vim.opt.conceallevel = 2

vim.opt.mouse = ''
vim.opt.shortmess = 'IF'

vim.opt.listchars = {
  eol = '¬',
  tab = '▸ ',
  trail = '×',
}

-- set update time for lsp hover
vim.opt.updatetime = 300

-- extend comment when hitting ENTER in insert mode
vim.opt.formatoptions:append('r')

-- folding
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Buildt in plugins
vim.cmd('packadd nvim.undotree')
