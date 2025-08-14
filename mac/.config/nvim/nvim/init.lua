local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"

local functions = require('functions')

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require("config.lazy")
vim.cmd.source(vimrc)
vim.cmd('highlight WinSeparator guifg=gray')

require("lsp")

vim.diagnostic.config({
  signs = false,
  underline = true,
  float = {
    border = "rounded",
    scope = "cursor",
  },
})

vim.filetype.add({
  extension = {
    js = 'javascript',
  },
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

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focus = false,
      anchor = "NW",
    })
  end,
})


require('commands')
require('hotkeys')
