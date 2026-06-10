vim.api.nvim_create_user_command("RunSilent",
  function(opts)
    vim.cmd(":silent !" .. opts.args)
    vim.cmd.redraw()
  end,
  { nargs = "*" }
)

vim.notify("markdown ftplugin loaded")

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


vim.keymap.set("n", "j", "gj", { buffer = true })
vim.keymap.set("n", "k", "gk", { buffer = true })

-- pandoc , markdown
vim.keymap.set("n", "<leader>pc", "<cmd>RunSilent pandoc --pdf-engine=typst -o /tmp/vim-pandoc-out.pdf %<cr>",
  { buffer = true })
vim.keymap.set("n", "<leader>pp", "<cmd>!xdg-open /tmp/vim-pandoc-out.pdf<cr>", { buffer = true })


-------------------- TODO Plugin ------------------------------
local todo_text = "- [ ] "
local checkbox_start = 3
local checkbox_end = 4

-- Find to do pattern
-- Match to do pattern at start of line regardless of case used to complete
local regex_todo = vim.regex("^- \\[ \\]")
local regex_todo_filled = vim.regex("\\c^- \\[x\\]")

local function insert_todo()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, { todo_text })
end

local function toggle_todo()
  -- Get the current line
  local line = vim.api.nvim_get_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  local is_todo = regex_todo:match_str(line)
  local is_todo_filled = regex_todo_filled:match_str(line)

  if is_todo then
    vim.api.nvim_buf_set_text(0, row - 1, checkbox_start, row - 1, checkbox_end, { "X" })
  elseif is_todo_filled then
    vim.api.nvim_buf_set_text(0, row - 1, checkbox_start, row - 1, checkbox_end, { " " })
  end
end

vim.keymap.set("n", "<leader>td", insert_todo, { buffer = true })
vim.keymap.set("n", "<leader>tc", toggle_todo, { buffer = true })
