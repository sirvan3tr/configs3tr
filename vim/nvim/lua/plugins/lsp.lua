return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()

      -- Pyright LSP setup with venv detection
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function()
          -- Detect virtual environment (.venv) if present, searching from file directory upwards
          local function get_python_path()
            local file_dir = vim.fn.expand('%:p:h')
            local dir = file_dir
            for _ = 1, 10 do -- Search up to 10 levels up
              local venv_python = dir .. '/.venv/bin/python'
              if vim.fn.executable(venv_python) == 1 then
                return venv_python
              end
              local parent = vim.fn.fnamemodify(dir, ':h')
              if parent == dir then
                break -- Reached root
              end
              dir = parent
            end
            return vim.fn.exepath('python3') -- Fallback
          end

          -- Define Pyright config with detected Python path
          local config = {
            cmd = { vim.fn.stdpath('data') .. '/mason/bin/pyright-langserver', '--stdio' },
            filetypes = { 'python' },
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = 'basic',
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                },
                pythonPath = get_python_path(),
              },
            },
          }

          -- Start LSP with the config
          vim.lsp.start(config)

          -- Debug command: :PythonPath to see detected Python path
          vim.api.nvim_buf_create_user_command(0, 'PythonPath', function()
            print('Detected Python path: ' .. get_python_path())
          end, {})

          -- Keymaps
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true, desc = 'Hover documentation' })
          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = true, desc = 'Signature help' })

          -- Python execution keymaps
          vim.keymap.set('n', '<F5>', function()
            vim.cmd('!uv run %')
          end, { buffer = true, desc = 'Run Python file' })

          vim.keymap.set('n', '<F6>', function()
            vim.cmd('!uv run -m doctest %')
          end, { buffer = true, desc = 'Run doctests' })

          vim.keymap.set('n', '<leader>t', function()
            vim.cmd('!pytest')
          end, { buffer = true, desc = 'Run pytest' })
        end,
      })

      -- TypeScript/JavaScript LSP setup
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        callback = function()
          local config = {
            cmd = { vim.fn.stdpath('data') .. '/mason/bin/typescript-language-server', '--stdio' },
            filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = 'all',
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                },
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints = 'all',
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                },
              },
            },
          }

          vim.lsp.start(config)

          -- Keymaps
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true, desc = 'Hover documentation' })
          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = true, desc = 'Signature help' })
        end,
      })
    end,
  },

  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        python = { 'ruff' }, -- Use Ruff for Python linting
        javascript = { 'eslint' },
        typescript = { 'eslint' },
        javascriptreact = { 'eslint' },
        typescriptreact = { 'eslint' },
      }

      -- Auto-run linting on save
      vim.api.nvim_create_autocmd('BufWritePost', {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
