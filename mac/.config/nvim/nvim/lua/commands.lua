vim.api.nvim_create_user_command(
  'Reformat',
  function()
    vim.lsp.buf.format()
  end,
  { desc = 'Reformat buffer using the active language server' }
)
