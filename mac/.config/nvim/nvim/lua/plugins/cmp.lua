return {
  {
    'hrsh7th/nvim-cmp',
    version = false, -- Use latest commit, not stable release
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',   -- LSP completions
      'hrsh7th/cmp-buffer',     -- Words from current buffer
      'hrsh7th/cmp-path',       -- File paths
      'hrsh7th/cmp-cmdline',    -- Command line completions
      'L3MON4D3/LuaSnip',       -- Snippet plugin
      'saadparwaiz1/cmp_luasnip', -- Snippet completions
      'onsails/lspkind.nvim',   -- symbols
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require("luasnip")
      local lspkind = require('lspkind')
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          keyword_length = 2,
          autocomplete = false,
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
          ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end),

          ['<Tab>'] = cmp.mapping(function(fallback)
            if not cmp.visible() then
              cmp.complete()
            end
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        }),
        preselect = cmp.PreselectMode.None,
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = '...',
            symbol_map = { Supermaven = "", }
          })
        },
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'supermaven' },
        }, {
          { name = 'buffer' },
        }),
      })
      -- Enable path completions on command line
      cmp.setup.cmdline(':', {
        sources = {
          { name = 'path' },
          { name = 'cmdline' },
        },
      })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        disable_keymaps = true
      })
    end,
  }
}
