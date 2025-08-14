-- install language servers first
-- mac: brew install typescript-language-server pyright gopls # ...

require("lsp.go")
require("lsp.ts")
require("lsp.lua")


-- lsp mappings
vim.api.nvim_create_augroup('UserLspConfig', {})
vim.api.nvim_clear_autocmds({ group = 'UserLspConfig' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = 'UserLspConfig',
  callback = function(ev)
    local opts = { buffer = ev.buf, desc = "LSP: " } -- Use 'desc' for clarity

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'LSP: Go to definition' })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = 'LSP: Go to declaration' })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, desc = 'LSP: Go to implementation' })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = 'LSP: Find references' })
    vim.keymap.set('n', 'rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'LSP: Rename symbol' })
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = 'LSP: Go to type definition' })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'LSP: Show hover doc' })
    vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_next, { buffer = ev.buf, desc = 'LSP: Go to previous diagnostic' })
    vim.keymap.set('n', '<C-b>', vim.diagnostic.goto_prev, { buffer = ev.buf, desc = 'LSP: Go to next diagnostic' })
    --    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action,  { buffer = ev.buf, desc = 'LSP: Code action' })
  end,
})

