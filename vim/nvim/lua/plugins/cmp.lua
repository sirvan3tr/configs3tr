return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet engine
    {
      'L3MON4D3/LuaSnip',
      build = "make install_jsregexp", -- optional for regex support
      dependencies = {
        'rafamadriz/friendly-snippets', -- optional: pre-made snippets
      },
    },
    'saadparwaiz1/cmp_luasnip',
    
    -- Completion sources
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-signature-help', -- for function signature help

    -- UI enhancements
    'onsails/lspkind.nvim',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')
    
    -- Load friendly-snippets if installed
    require('luasnip.loaders.from_vscode').lazy_load()
    
    -- Add custom snippets
    local ls = require('luasnip')
    ls.add_snippets('python', {
      ls.snippet('sep', {
        ls.text_node('# ============================================================================'),
      }),
    })
    ls.add_snippets('javascript', {
      ls.snippet('sep', {
        ls.text_node('// ============================================================================'),
      }),
    })
    ls.add_snippets('typescript', {
      ls.snippet('sep', {
        ls.text_node('// ============================================================================'),
      }),
    })
    
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'text', -- show only text, no symbols to avoid ? marks
          maxwidth = 50, -- max width
        }),
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        -- Tab to jump to next snippet placeholder
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' }, -- function signatures
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
        { name = 'path' },
      })
    })

    -- Set up command-line completion
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })

    -- Set up search completion
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })
  end,
}