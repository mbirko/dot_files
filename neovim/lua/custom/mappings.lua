-- Inspired by and Yanked from [thecodinglab](https://github.com/thecodinglab/neovim-config/blob/master/lua/custom/mappings.lua)
-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- clear highlight
vim.keymap.set('n', '<ESC>', '<CMD>noh<cr>', opts)

-- undotree
vim.keymap.set('n', '<leader>u', require('undotree').open)
--
-- lsp
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

-- save
vim.keymap.set('n', '<leader>w', '<cmd>silent write<cr>', opts)

-- explorer
vim.keymap.set('n', '-', '<cmd>Oil<cr>', opts)

local function hover_highlight(client, bufnr)
  if not client.server_capabilities.documentHighlightProvider then
    return
  end

  vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    buffer = bufnr,
    group = vim.api.nvim_create_augroup('lsp_document_highlight_hold', { clear = false }),
    callback = function()
      vim.lsp.buf.document_highlight()
    end,
  })

  vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    buffer = bufnr,
    group = vim.api.nvim_create_augroup('lsp_document_highlight_moved', { clear = false }),
    callback = function()
      vim.lsp.buf.clear_references()
    end,
  })
end

local function autoformat(client, bufnr)
  -- disable formatting using tsserver as it takes forever and slows down
  -- my development workflow
  if client.name == 'tsserver' then
    return
  end

  -- enable formatting using eslint
  if client.name == 'eslint' then
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
  end

  if not client.server_capabilities.documentFormattingProvider then
    return
  end

  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    buffer = bufnr,
    group = vim.api.nvim_create_augroup('lsp_autoformat', { clear = false }),
    callback = function()
      vim.lsp.buf.format({ bufnr = bufnr, async = false, timeout_ms = 150 })
    end,
  })
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_mappings', {}),
  callback = function(event)
    local bufnr = event.buf

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      -- this should never happen though just to be sure
      return
    end

    hover_highlight(client, bufnr)
    autoformat(client, bufnr)
  end,
})
