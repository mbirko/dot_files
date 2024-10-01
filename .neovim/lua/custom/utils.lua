local M = {
  MAX_FILESIZE = 1000000, -- 1mb
}

function M.is_large_file(filename)
  local ok, stat = pcall(vim.uv.fs_stat, filename)
  if ok and stat and stat.size > M.MAX_FILESIZE then
    return true
  end
end

function M.is_large_buffer(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file then
    return M.is_large_file(file)
  end

  local num_lines = vim.api.nvim_buf_line_count(bufnr)
  local byte_size = vim.api.nvim_buf_get_offset(bufnr, num_lines)
  return byte_size > M.MAX_FILESIZE
end

function M.get_visual_selection()
  local a_prev = vim.fn.getreg('a')
  local mode = vim.fn.mode()

  if mode ~= 'v' and mode ~= 'V' then
    vim.cmd([[normal! gv]])
  end
  vim.cmd([[silent! normal! "aygv]])

  local text = vim.fn.getreg('a')
  vim.fn.setreg('a', a_prev)

  return text
end

return M
