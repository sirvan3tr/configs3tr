# Neovim Configuration

This is my personal Neovim configuration using Lazy.nvim for plugin management. It includes imports from an old Vim config for familiarity.

## Prerequisites

- **Neovim**: Version 0.11+ (for the latest LSP API).
- **Git**: For cloning plugins.
- **Node.js** (optional): Some LSP servers or tools may require it.
- **Python**: For Python development (Pyright LSP).
- **Nerd Font** (optional): For icons in the UI (e.g., Fira Code Nerd Font). Install via `brew install font-fira-code-nerd-font` on macOS.

## Installation

1. **Clone this config**:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

2. **Install Lazy.nvim and plugins**:
   - Open Neovim: `nvim`
   - Run `:Lazy sync` to install all plugins.

3. **Install LSP servers and tools**:
   - Run `:Mason` in Neovim.
   - Install the following:
     - `pyright` (Python LSP for autocompletions).
     - `ruff` (Python linter).
     - Any other LSPs you need (e.g., for Lua, JS, etc.).

4. **Set Terminal Font** (for icons):
   - If using a Nerd Font, set your terminal (e.g., iTerm2) to use it for proper icon display.

## Features

- **Completion & Snippets**: nvim-cmp with LuaSnip and friendly-snippets. Custom snippets: `sep` for Python comment separator.
- **Navigation**: Neoscroll for smooth scrolling, relative line numbers for quick jumps.
- **LSP**: Pyright for Python and tsserver for TypeScript/JavaScript autocompletions, hover info, function signatures, and support for installed packages. Automatically detects `.venv` virtual environments for Python.
- **Linting**: Ruff for Python, ESLint for JavaScript/TypeScript.
- **Formatting**: Conform for auto-format on save (Ruff for Python, Prettier for JS/TS, Stylua for Lua).
- **UI**: Cyberdream colorscheme, bordered completion/hover boxes, Lualine status line, Bufferline tabs, indent guides.
- **File Management**: Nvim-tree file explorer, Telescope fuzzy finder, Harpoon quick navigation.
- **Git**: Gitsigns and Fugitive for git integration, Octo for GitHub PR reviews, Diffview for commit diff viewing.
- **Diagnostics**: Trouble for better error/warning views.
- **Project Management**: Alpha dashboard on startup, Project.nvim for project detection, Todo-comments for highlighting TODOs.
- **Code Outline & Minimap**: Aerial for code outline (classes/functions, auto-opens on left), minimap.vim for file minimap (auto-starts on right).
- **Keymaps**:
  - `<C-Space>`: Trigger completion.
  - `<Tab>/<S-Tab>`: Navigate completions/snippets.
  - `K`: Hover for definitions/types (in Python buffers).
  - `<C-k>` (insert mode): Show function signature help.
  - `<C-h/j/k/l>`: Navigate splits.
  - `<C-Tab>/<C-S-Tab>`: Switch buffers.
  - `<C-n>`: Toggle Nvim-tree.
  - `<leader>ff`: Find files (Telescope).
  - `<leader>fg`: Live grep (Telescope).
  - `<leader>fb`: Buffers (Telescope).
  - `<leader>fh`: Help tags (Telescope).
  - `<leader>fp`: Projects (Telescope).
  - `<leader>f`: Format buffer (Conform).
  - `<leader>a`: Add file to Harpoon.
  - `<C-e>`: Toggle Harpoon menu.
  - `<leader>1/2/3/4`: Jump to Harpoon files 1-4.
  - `<leader>xx`: Toggle Trouble diagnostics.
  - `<F5>` (Python): Run file.
  - `<F6>` (Python): Run doctests.
  - `<leader>t` (Python): Run pytest.
  - `<leader>o`: Toggle Aerial code outline (auto-opens for files with symbols).
  - `:MinimapToggle`: Toggle minimap (auto-starts).
  - `:DiffviewOpen`: Open diff view (e.g., `:DiffviewOpen HEAD~1`).
  - `:DiffviewFileHistory`: View file history.
  - `:DiffviewClose`: Close diff view.
  - `:Octo pr list`: List PRs.
  - `:Octo review start`: Start review mode.
  - Folding: `za` (toggle), `zo` (open), `zc` (close), `zR` (open all), `zM` (close all).

- **Commands**:
  - `:TexCompile`: Compile LaTeX file.
  - `:PythonPath`: Debug Python path for LSP.

## Customization

- Plugins are in `lua/plugins/`.
- LSP config in `lua/plugins/lsp.lua`.
- CMP config in `lua/plugins/cmp.lua`.
- Lazy config in `lua/config/lazy.lua`.

Modify as needed. Run `:Lazy sync` after changes.

## Troubleshooting

- If LSP doesn't work: Ensure servers are installed via `:Mason`.
- Icons showing as `?`: Install a Nerd Font and set in terminal.
- Reload config: `:source ~/.config/nvim/init.lua` or restart Neovim.