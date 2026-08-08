vim.notify("typst ftplugin loaded")

vim.opt_local.spell = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

-- folding
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.foldtext = require("custom.modules.foldtext")


vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", {expr = true, silent = ture, buffer = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", {expr = true, silent = ture, buffer = true })


