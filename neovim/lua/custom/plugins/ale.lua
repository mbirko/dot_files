return {
  'dense-analysis/ale',
  ft = "sql",
  config = function()
    -- Configuration goes here.
    local g = vim.g
    g.ale_use_neovim_diagnostics_api = 1
    g.ale_disable_lsp = 1
    g.ale_linters_explicit = 1
    g.ale_fix_on_save = 1
    g.ale_cspell_executeable = 'cspell'
    g.ale_linters = { sql = { 'cspell' } }
    g.ale_fixers = {
      sql = { 'remove_trailing_lines', 'trim_whitespace' },
    }
  end
}
