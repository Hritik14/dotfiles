return {
  "rebelot/kanagawa.nvim",
  priority = 1000,     -- Ensure it loads early
  lazy = false,        -- Load immediately for colorscheme
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
          Normal   = { bg = "#000000" },
          NormalNC = { bg = "#000000" },
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
}
