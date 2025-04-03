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
  require('custom.plugins.indent-blankline'),
  --  require('custom.plugins.vimwiki'),
}, {
  defaults = { lazy = true, },
  performance = {
    rtp = {
      reset = false,
    },
  },
})
---sets the PYTHONPATH env variable bysearching upward for `.venv` folder and fiding the site-packages within that
---if no `.venv` is found, its sets to user-site
local function set_python_venv()
  ---wraps find returning signle string path or nil
  ---@param path_name string
  ---@param search_path string
  ---@param stop_path string
  ---@param upward boolean
  ---@return any
  local function find_path_to_dir(path_name, search_path, stop_path, upward)
    local venv_path = vim.fs.find(path_name, {
      upward = upward,
      type = "directory",
      path = search_path,
      stop = stop_path
    })

    if venv_path and #venv_path > 0 then
      vim.notify("found path: " .. venv_path[1], vim.log.levels.TRACE)
      return venv_path[1]
    else
      vim.notify("WARN: " .. path_name .. "was not found", vim.log.levels.WARN)
      return nil
    end
  end

  -- Check if PYTHONPATH is already set, to not search more then necessary
  if vim.env.PYTHONPATH ~= nil and vim.env.PYTHONPATH ~= "" then
    vim.notify("PYTHONPATH was not nil or empty: " .. vim.env.PYTHONPATH, vim.log.levels.TRACE)
    return
  end

  -- get current working directory
  local search_path = vim.fn.getcwd()
  -- stopping searching upward at home directory
  local stop_path = vim.env.HOME
  -- find path of virtual enviorment searching upward
  local venv_path = find_path_to_dir(".venv", search_path, stop_path, true)
  if venv_path then
    -- finding site-packages path within environment
    local python_path = find_path_to_dir("site-packages", venv_path, stop_path, false)
    if python_path then
      vim.env.PYTHONPATH = python_path
      vim.notify("PYTHONPATH is set to: " .. python_path, vim.log.levels.OFF)
    else
      -- this sould not happen, just to be sure
      python_path = vim.fn.system("python3 -m site --user-site")
      vim.env.PYTHONPATH = python_path
      vim.notify("site-packages was not found inside .venv, using global instead: " .. python_path, vim.log.levels.WARN)
    end
  else
    -- No virtual enviorment found
    -- setting path to global installation
    local python_path = vim.fn.system("python3 -m site --user-site")
    vim.env.PYTHONPATH = python_path
    vim.notify("sno venv was found, using global instead: " .. python_path, vim.log.levels.WARN)
  end
end
-- creating filetype autocommand to set python path when a python file is opened
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(event)
    set_python_venv()
  end
})
