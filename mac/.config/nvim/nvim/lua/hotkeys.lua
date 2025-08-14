local expand = function(fallback)
  local luasnip = require('luasnip')
  local suggestion = require('supermaven-nvim.completion_preview')

  if luasnip.expandable() then
    luasnip.expand()
  elseif suggestion.has_suggestion() then
    suggestion.on_accept_suggestion()
  else
    fallback()
  end
end

vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format() end, { desc = 'Format buffer with LSP' })
vim.keymap.set('n', 'cf', function() vim.lsp.buf.format() end, { desc = 'Format buffer with LSP' })
vim.keymap.set('t', '<leader><Esc>', [[<C-\><C-n>]], { desc = 'Escape from terminal mode' })
vim.keymap.set('i', '<C-t>', expand, { desc = 'Accept supermaven completion' })
vim.keymap.set('n', 'gb', ':Buffers<CR>', { desc = 'List buffers' })
vim.keymap.set('n', 'gm', ':Marks<CR>', { desc = 'List marks' })
vim.keymap.set('n', 'gt', ':BTags<CR>', { desc = 'List buffer tags' })
vim.keymap.set('n', 'ggt', ':Tags<CR>', { desc = 'List all tags' })
vim.keymap.set('n', 'gcm', ':Commits<CR>', { desc = 'List commits' })
vim.keymap.set('n', 'gcb', ':BCommits<CR>', { desc = 'List buffer commits' })
