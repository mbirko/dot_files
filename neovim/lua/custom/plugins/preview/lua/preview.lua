local M = {}

local config = {
  plantuml_command = "plantuml -o %o %s",
  render_command = "feh %s"
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})
end

local function get_current_buffer_content()
  return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

local function generate_temp_filepath(extention)
  return vim.fn.tempname() .. extention
end

function M.render()
  local buftybe = vim.bo.filetype
  if buftybe ~= "plantuml" then
    if vim.api.nvim_get_current_line() ~= "" then
      vim.notify("Not a plantuml buffer. filetype is: " .. buftybe, vim.log.levels.WARN)
    end
  end
  -- Get temp file path
  local temp_diagram_path = generate_temp_filepath(".png")
  -- construct command
  local plantuml_cmd = config.plantuml_command:gsub("%%s", vim.fn.expand("%")):gsub("%%o",
    vim.fn.fnamemodify(temp_diagram_path, ":h"))
  vim.notify("Executing:" .. plantuml_cmd, vim.log.levels.WARN)
  -- run the command
  vim.fn.jobstart(plantuml_cmd)
end

vim.api.nvim_create_user_command('Preview', function(_)
  local ok, result = pcall(M.render())
  if not ok then
    vim.notify("Rendering not successful: " .. result, vim.log.levels.ERROR)
  end
end, {})

return M
