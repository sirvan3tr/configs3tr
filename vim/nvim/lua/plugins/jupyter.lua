-- Register .ipynb filetype
vim.filetype.add({
  extension = {
    ipynb = 'json',
  },
})

-- Custom command to view .ipynb files in readable format
vim.api.nvim_create_user_command('JupyterView', function()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  
  if not file:match('%.ipynb$') then
    vim.notify('Not a .ipynb file', vim.log.levels.ERROR)
    return
  end
  
  -- Use Python to extract and format notebook cells
  local python_script = [[
import json
import sys

try:
    with open(sys.argv[1], 'r') as f:
        nb = json.load(f)
    
    output = []
    for i, cell in enumerate(nb.get('cells', []), 1):
        cell_type = cell.get('cell_type', 'unknown')
        source = ''.join(cell.get('source', []))
        
        if cell_type == 'markdown':
            output.append(f"# Cell {i} [Markdown]")
            output.append("=" * 50)
            output.append(source)
        elif cell_type == 'code':
            output.append(f"# Cell {i} [Code]")
            output.append("=" * 50)
            output.append(source)
            if cell.get('outputs'):
                output.append("\n# Output:")
                for out in cell['outputs']:
                    if 'text' in out:
                        output.append(''.join(out['text']))
        output.append("\n" + "-" * 50 + "\n")
    
    print(''.join(output))
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
]]
  
  -- Write temp script and execute
  local temp_script = vim.fn.tempname() .. '.py'
  vim.fn.writefile(vim.split(python_script, '\n'), temp_script)
  
  local result = vim.fn.system(string.format('python3 %s %s', temp_script, vim.fn.shellescape(file)))
  vim.fn.delete(temp_script)
  
  if vim.v.shell_error == 0 then
    -- Open in a new buffer
    vim.cmd('new')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, '\n'))
    vim.cmd('set filetype=python')
    vim.cmd('set readonly')
    vim.cmd('setlocal nomodifiable')
  else
    vim.notify('Failed to parse notebook: ' .. result, vim.log.levels.ERROR)
  end
end, { desc = 'View .ipynb file in readable format' })

-- Auto-format JSON when opening .ipynb files (makes raw JSON readable)
-- This is now optional - use :JupyterFormat to format manually if auto-format causes issues
vim.api.nvim_create_user_command('JupyterFormat', function()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  
  if not file:match('%.ipynb$') then
    vim.notify('Not a .ipynb file', vim.log.levels.ERROR)
    return
  end
  
  if file == '' or not vim.fn.filereadable(file) then
    vim.notify('File not readable', vim.log.levels.ERROR)
    return
  end
  
  vim.cmd('set filetype=json')
  
  local formatted = vim.fn.system('python3 -m json.tool ' .. vim.fn.shellescape(file))
  if vim.v.shell_error == 0 and formatted ~= '' then
    local lines = vim.split(formatted, '\n')
    if lines[#lines] == '' then
      table.remove(lines)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'modified', false)
    vim.notify('Formatted JSON', vim.log.levels.INFO)
  else
    vim.notify('Failed to format JSON', vim.log.levels.ERROR)
  end
end, { desc = 'Format .ipynb JSON file' })

-- Optional: Auto-format on open (comment out if it causes issues)
--[[
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*.ipynb',
  callback = function()
    vim.cmd('JupyterFormat')
  end,
})
--]]

return {
  -- Configure magma-nvim for Jupyter kernel execution (already installed)
  -- This allows you to execute Python code in a Jupyter kernel from Neovim
  {
    'dccsillag/magma-nvim',
    build = ':UpdateRemotePlugins',
    ft = { 'python', 'julia', 'r' },
    config = function()
      vim.g.magma_automatically_open_output = true
      vim.g.magma_image_provider = 'ueberzug'
      vim.g.magma_wrap_output = true
      vim.g.magma_output_window_borders = true
      vim.g.magma_cell_highlight_group = 'CursorLine'

      -- Keymaps for magma (Jupyter kernel execution)
      vim.keymap.set('n', '<leader>r', ':MagmaEvaluateOperator<CR>', { desc = 'Magma evaluate operator' })
      vim.keymap.set('n', '<leader>rr', ':MagmaEvaluateLine<CR>', { desc = 'Magma evaluate line' })
      vim.keymap.set('v', '<leader>r', ':MagmaEvaluateVisual<CR>', { desc = 'Magma evaluate visual' })
      vim.keymap.set('n', '<leader>rc', ':MagmaReinit<CR>', { desc = 'Magma reinit kernel' })
      vim.keymap.set('n', '<leader>rd', ':MagmaDelete<CR>', { desc = 'Magma delete output' })
      vim.keymap.set('n', '<leader>ro', ':MagmaShowOutput<CR>', { desc = 'Magma show output' })
    end,
  },
}
