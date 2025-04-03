local function configure_lsp_server(server, extra)
  local lspconfig = require('lspconfig')[server]

  local config = {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  }

  config.capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

  local cmp_status_ok, cmp = pcall(require, 'cmp_nvim_lsp')
  if cmp_status_ok then
    config.capabilities = vim.tbl_deep_extend('force', config.capabilities, cmp.default_capabilities())
  end

  local coq_status_ok, coq = pcall(require, 'coq')
  if coq_status_ok then
    config = coq.lsp_ensure_capabilities(config)
  end

  if extra then
    config = vim.tbl_deep_extend('force', config, extra)
  end

  lspconfig.setup(config)
  return true
end


return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'j-hui/fidget.nvim',
      'folke/lazydev.nvim',
    },
    event = 'VeryLazy',

    config = function()
      configure_lsp_server('yamlls')
      configure_lsp_server('fsautocomplete')         -- NOTE: Fsharp auto complete
      configure_lsp_server('fsharp_language_server') -- NOTE: Fsharp language server
      -- configure_lsp_server('dprint',
      configure_lsp_server('lua_ls')                 -- NOTE: Lua language server
      configure_lsp_server('ts_ls')                  -- NOTE: TypeScript language server
      configure_lsp_server('eslint')                 -- NOTE: JavaScript language server
      configure_lsp_server('clangd', {
        -- NOTE: all supported filetypes (see :help lspconfig-all) without protobuf
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
      })

      -- configure_lsp_server('hls') -- NOTE: haskell-language-server

      configure_lsp_server('pylsp', {
        settings = {
          pylsp = {
            cmd = { "pylsp" },
            plugins = {
              pycodestyle = {
                enabled = false,
                ignore = { 'W391' },
                maxLineLength = 100
              },

              ruff = {
                enabled = true,       -- Enable the plugin
                formatEnabled = true, -- Enable formatting using ruffs formatter
                -- extendSelect = { "I" },  -- Rules that are additionally used by ruff
                -- extendIgnore = { "C90" },  -- Rules that are additionally ignored by ruff
                -- format = { "I" },  -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
                -- severities = { ["D212"] = "I" },  -- Optional table of rules where a custom severity is desired
                unsafeFixes = false, -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action

                -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
                --
                lineLength = 88,              -- Line length to pass to ruff checking and formatting
                exclude = { "__about__.py" }, -- Files to be excluded by ruff checking
                select = {},                  -- Rules to be enabled by ruff
                ignore = {},                  -- Rules to be ignored by ruff
                -- perFileIgnores = { ["__init__.py"] = "CPY001" },  -- Rules that should be ignored for specific files
                preview = false,              -- Whether to enable the preview style linting and formatting.
                targetVersion = "py310",      -- The minimum python version to target (applies for both linting and formatting).
              },
            }
          }
        }
      }) -- NOTE: python-language-server
      -- configure_lsp_server('rust_analyzer') -- NOTE: rust-analyzer
      -- configure_lsp_server('texlab')
      configure_lsp_server('nixd', {
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }",
            },
            formatting = { 
              command = { "nixfmt" },
            },
            options = {
              nixos = {
                expr = '(builtins.getFlakes "/etc/nixos/flake.nix").nixosConfigurations.T14.options',
              },
            },
          },
        },
      })
    end,
  },

  { 'folke/lazydev.nvim', opts = {} },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    cmd = { 'Trouble' },
    keys = {
      { '<leader>xx', '<cmd>Trouble<cr>' },
      { '<leader>xd', '<cmd>Trouble diagnostics toggle<cr>' },
    },

    opts = {},
  },

  {
    'j-hui/fidget.nvim',

    event = 'VeryLazy',

    opts = {
      notification = {
        -- suggested by catppuccin
        window = {
          winblend = 0,
          border = "rounded",
        },

        override_vim_notify = true,
      },
    },
  }
}
