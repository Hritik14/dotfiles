-- install following:
-- brew install fzf bat ripgrep the_silver_searcher perl universal-ctags
return {
  'junegunn/fzf.vim',
  dependencies = { 'junegunn/fzf' },
  event = "VeryLazy",
}
