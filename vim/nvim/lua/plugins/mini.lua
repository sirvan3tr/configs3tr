return {
  {
    'nvim-mini/mini.files',
    version = false,
    config = function()
      require('mini.files').setup({
        windows = {
          preview = true,
          width_focus = 30,
          width_preview = 30,
        },
        options = {
          use_as_default_explorer = true,
        },
      })

      local show_dotfiles = true
      local filter_show = function(fs_entry) return true end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require('mini.files').set_filter(new_filter)
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak left-hand side of mapping to your liking
          vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id, desc = 'Toggle dotfiles' })
        end,
      })

      vim.keymap.set('n', '<leader>mf', function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.fnamemodify(buf_name, ':p')
        if path:match('^oil://') or path:match('^oil:') then
          path = path:gsub('^oil://', ''):gsub('^oil:', '')
        end

        if path == "" or path == "." then
          path = vim.fn.getcwd()
        end

        require('mini.files').open(path, true)
      end, { desc = 'Open mini.files (directory of current file)' })

      vim.keymap.set('n', '<leader>mF', function()
        require('mini.files').open(vim.fn.getcwd(), true)
      end, { desc = 'Open mini.files (cwd)' })
    end,
  },
}
