-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
    {
      "scottmckendry/cyberdream.nvim",
      lazy = false,
      priority = 1000,
    },
    {
      "stevearc/dressing.nvim",
      opts = {},
    },
    {
      "onsails/lspkind.nvim",
    },
    -- Imported plugins from old Vim config
    {
      "preservim/nerdtree",
      cmd = "NERDTreeToggle",
      keys = {
        { "<C-n>", ":NERDTreeToggle<CR>", desc = "Toggle NERDTree" },
      },
    },
    "tpope/vim-surround",
    "junegunn/vim-easy-align",
    "vim-airline/vim-airline",
    "vim-airline/vim-airline-themes",
    "jpalardy/vim-slime",
    "Glench/Vim-Jinja2-Syntax",
    "bhurlow/vim-parinfer",
    "junegunn/fzf",
    "tjammer/focusedpanic.vim",
    "Mizux/vim-colorschemes",
    "franbach/miramare",
    "joshdick/onedark.vim",
    "drewtempelmeyer/palenight.vim",
    -- Clojure and Go plugins (if needed)
    { "tpope/vim-fireplace", ft = "clojure" },
    -- Pro user plugins
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local ok, configs = pcall(require, "nvim-treesitter.configs")
        if ok then
          configs.setup({
            ensure_installed = { "python", "lua", "vim", "javascript", "html", "css", "typescript", "tsx" }, -- Add languages as needed
            highlight = { enable = true },
            indent = { enable = true },
            fold = { enable = true },
          })
        else
          vim.notify("nvim-treesitter not ready, run :TSUpdate", vim.log.levels.WARN)
        end
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
      config = function()
        local telescope = require("telescope")
        telescope.setup({
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            },
          },
        })
        telescope.load_extension("fzf")
      end,
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
        { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
      },
    },
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      keys = {
        { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
      },
      config = function()
        require("nvim-tree").setup()
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end,
    },
    {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup()
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup()
      end,
    },
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      keys = {
        { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
        { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
        { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      },
    },
    {
      "goolord/alpha-nvim",
      config = function()
        require("alpha").setup(require("alpha.themes.startify").config)
      end,
    },
    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          python = { "ruff_format" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          lua = { "stylua" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      },
    },
    {
      "tpope/vim-fugitive",
      cmd = "Git",
    },
    {
      "ThePrimeagen/harpoon",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("harpoon").setup()
        vim.keymap.set('n', '<leader>a', require('harpoon.mark').add_file, { desc = 'Add file to Harpoon' })
        vim.keymap.set('n', '<C-e>', require('harpoon.ui').toggle_quick_menu, { desc = 'Toggle Harpoon menu' })
        vim.keymap.set('n', '<leader>1', function() require('harpoon.ui').nav_file(1) end, { desc = 'Harpoon file 1' })
        vim.keymap.set('n', '<leader>2', function() require('harpoon.ui').nav_file(2) end, { desc = 'Harpoon file 2' })
        vim.keymap.set('n', '<leader>3', function() require('harpoon.ui').nav_file(3) end, { desc = 'Harpoon file 3' })
        vim.keymap.set('n', '<leader>4', function() require('harpoon.ui').nav_file(4) end, { desc = 'Harpoon file 4' })
      end,
    },
    -- Project management
    {
      "goolord/alpha-nvim",
      config = function()
        require("alpha").setup(require("alpha.themes.startify").config)
      end,
    },
    {
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup()
        require("telescope").load_extension("projects")
      end,
    },
    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("todo-comments").setup()
      end,
    },
    -- Code outline
    {
      "stevearc/aerial.nvim",
      config = function()
        require("aerial").setup({
          open_automatic = true,  -- Auto-open for files with symbols
          placement = "edge",
          default_direction = "prefer_left",  -- Open Aerial on the left
          on_attach = function(bufnr)
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
            vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
          end,
        })
        vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial outline" })
      end,
    },
    -- Minimap
    {
      "wfxr/minimap.vim",
      build = "cargo install --locked code-minimap",
      config = function()
        vim.g.minimap_width = 10
        vim.g.minimap_auto_start = 1  -- Auto-start minimap
        vim.g.minimap_auto_start_win_enter = 1  -- Auto-start when entering window
        -- Removed vim.g.minimap_left = 1 to keep on right
      end,
    },
    -- GitHub PR reviews
    {
      "pwntester/octo.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("octo").setup()
      end,
    },
    -- Diff viewer for commits
    {
      "sindrets/diffview.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
      "iamcco/markdown-preview.nvim",
      ft = "markdown",
      build = "cd app && npm install",
    },
    -- LSP enhancements
    {
      "ray-x/lsp_signature.nvim",
    },
    {
      "glepnir/lspsaga.nvim",
      config = function()
        require("lspsaga").setup({
          ui = {
            border = "rounded",
          },
          symbol_in_winbar = {
            enable = false,
          },
        })
      end,
    },
    -- File manager
    {
      "stevearc/oil.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("oil").setup({
          columns = { "icon" },
          keymaps = {
            ["<C-g>"] = false,
            ["<C-h>"] = false,
            ["<C-l>"] = false,
          },
        })
        vim.keymap.set("n", "<leader>fo", "<cmd>Oil<CR>", { desc = "Open parent directory" })
      end,
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Set the colorscheme
vim.cmd.colorscheme("cyberdream")

-- Imported settings from old Vim config
vim.opt.colorcolumn = "79,120"
vim.opt.cursorline = true
vim.cmd([[hi ColorColumn guibg=#2d2d2d guifg=NONE ctermbg=236]])
vim.opt.wrap = true
vim.opt.textwidth = 80
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.showmatch = true

-- TypeScript 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "typescript.tsx" },
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
  end,
})
vim.opt.termguicolors = true
vim.opt.guifont = "FiraCode Nerd Font:h11"

-- Folding settings
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99  -- Start with all folds open
vim.opt.foldenable = true

-- Python highlighting
vim.g.python_highlight_all = 1

-- Keymaps from old config
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { desc = 'Move to split below' })
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { desc = 'Move to split above' })
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { desc = 'Move to split right' })
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { desc = 'Move to split left' })
vim.keymap.set('n', '<C-Tab>', ':bn<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<C-S-Tab>', ':bp<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>f', function() require('conform').format() end, { desc = 'Format buffer' })

-- Custom function (adapted to Lua)
vim.api.nvim_create_user_command('TexCompile', function()
  vim.cmd('write')
  vim.fn.system('pdflatex ' .. vim.fn.expand('%'))
end, {})

-- Surround mappings (vim-surround handles this)
-- Already handled by vim-surround plugin
