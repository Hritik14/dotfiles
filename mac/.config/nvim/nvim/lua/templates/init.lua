local templates_dir = vim.fn.stdpath("config") .. "/lua/templates/"

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*/posts/*.md",
  callback = function()
    print("AUTOCMD FIRED!")
    vim.cmd("0r " .. templates_dir .. "blog.md")
  end
})
