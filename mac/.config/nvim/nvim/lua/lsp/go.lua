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

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.keymap.set('n', 'cf', function()
      vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
      vim.lsp.buf.format()
    end, { desc = 'Format and organize imports', buffer = true })
  end,
})
