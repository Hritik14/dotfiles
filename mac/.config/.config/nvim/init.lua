local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"

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
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,         -- Ensure it loads early
    lazy = false,            -- Load immediately for colorscheme
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
	  return {
            Normal     = { bg = "#000000" },
            NormalNC   = { bg = "#000000" },
            --NormalFloat= { bg = "#000000" },
            --FloatBorder= { bg = "#000000" },
            -- Add more highlight groups here as needed
          }
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus",
        },
      })
    end,
  },
{
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
},
{
  'junegunn/fzf.vim',
  dependencies = { 'junegunn/fzf' },
  event = "VeryLazy",
},
{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- Optional image support for file preview: See `# Preview Mode` for more information.
    -- {"3rd/image.nvim", opts = {}},
    -- OR use snacks.nvim's image module:
    -- "folke/snacks.nvim",
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    filesystem = {
      hijack_netrw_behavior = "open_current",
        window = { 
          mappings = { 
            -- disable fuzzy finder 
            ["/"] = "noop" 
          } 
	  }
    },
    window = {
      position = "right",
    },
  event_handlers = {
    {
      event = "file_opened",
      handler = function()
		  require("neo-tree.command").execute({ action = "focus" })
      end
    },
  }
 },
},

  {
    'hrsh7th/nvim-cmp',
    version = false,   -- Use latest commit, not stable release
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- LSP completions
      'hrsh7th/cmp-buffer',   -- Words from current buffer
      'hrsh7th/cmp-path',     -- File paths
      'hrsh7th/cmp-cmdline',  -- Command line completions
      'L3MON4D3/LuaSnip',    -- Snippet plugin
      'saadparwaiz1/cmp_luasnip',    -- Snippet completions
      'onsails/lspkind.nvim', -- symbols
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

	  ["<Tab>"] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			  cmp.select_next_item()
		  elseif luasnip.locally_jumpable(1) then
			  luasnip.jump(1)
		  else
			  fallback()
		  end
	  end, { "i", "s" }),

	  ["<S-Tab>"] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			  cmp.select_prev_item()
		  elseif luasnip.locally_jumpable(-1) then
			  luasnip.jump(-1)
		  else
			  fallback()
		  end
	  end, { "i", "s" }),

        }),
        formatting = {
            format = lspkind.cmp_format({
                mode = "symbol",
                maxwidth = 50,
                ellipsis_char = '...',
                symbol_map = { Codeium = "", }
            })
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
	  { name = "codeium" },
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
    "Exafunction/windsurf.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        require("codeium").setup({
		enable_cmp_source = true,
		virtual_text = {
			enabled = true,
			idle_delay = 75,
			virtual_text_priority = 65535,
			map_keys = true,
		},
		key_bindings = {
			    -- Accept the current completion.
			    accept = "<C-h>",
			    -- Accept the next word.
			    accept_word = false,
			    -- Accept the next line.
			    accept_line = false,
			    -- Clear the virtual text.
			    clear = false,
			    -- Cycle to the next completion.
			    next = "<M-]>",
			    -- Cycle to the previous completion.
			    prev = "<M-[>",
			}
        })
    end
},
-- more plugins
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})

vim.cmd.source(vimrc)

-- install language servers first
-- mac: brew install typescript-language-server pyright gopls # ...
vim.lsp.enable('pyright')
vim.lsp.enable('tsserver')
vim.lsp.enable('gopls')

vim.diagnostic.config({
	  jump = { float = true },
	  signs = false,
})


function AllDiagnosticsStatus()
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warns = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  if errors > 0 or warns > 0 then
    return string.format(" %d  %d", errors, warns)
  else
    return ""
  end
end

vim.o.statusline = "%m %t %y %<%{&fileencoding?&fileencoding:&encoding} %{v:lua.AllDiagnosticsStatus()}%=C:%c L:%l %P"


vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
	vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
    vim.lsp.buf.format({
      filter = function(client)
        return client.name == "gopls"
      end,
      async = false,
    })
  end,
})

require("lspconfig").gopls.setup({
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      completeUnimported = true,
      usePlaceholders = true,
    },
  },
})


-- lsp mappings
vim.api.nvim_create_augroup('UserLspConfig', {})
vim.api.nvim_clear_autocmds({ group = 'UserLspConfig' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = 'UserLspConfig',
  callback = function(ev)
    local opts = { buffer = ev.buf, desc = "LSP: " } -- Use 'desc' for clarity

    vim.keymap.set('n', 'gd',  vim.lsp.buf.definition,         { buffer = ev.buf, desc = 'LSP: Go to definition' })
    vim.keymap.set('n', 'gD',  vim.lsp.buf.declaration,        { buffer = ev.buf, desc = 'LSP: Go to declaration' })
    vim.keymap.set('n', 'gi',  vim.lsp.buf.implementation,     { buffer = ev.buf, desc = 'LSP: Go to implementation' })
    vim.keymap.set('n', 'gr',  vim.lsp.buf.references,         { buffer = ev.buf, desc = 'LSP: Find references' })
    vim.keymap.set('n', 'rn',  vim.lsp.buf.rename,             { buffer = ev.buf, desc = 'LSP: Rename symbol' })
    vim.keymap.set('n', 'gy',  vim.lsp.buf.type_definition,    { buffer = ev.buf, desc = 'LSP: Go to type definition' })
    vim.keymap.set('n', 'K',   vim.lsp.buf.hover,              { buffer = ev.buf, desc = 'LSP: Show hover doc' })
    vim.keymap.set('n', '<C-n>',  vim.diagnostic.goto_prev,       { buffer = ev.buf, desc = 'LSP: Go to previous diagnostic' })
    vim.keymap.set('n', '<C-b>',  vim.diagnostic.goto_next,       { buffer = ev.buf, desc = 'LSP: Go to next diagnostic' })
--    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action,  { buffer = ev.buf, desc = 'LSP: Code action' })
  end,
})
