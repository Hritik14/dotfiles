if exists('g:vscode')
    nnoremap <space> :call VSCodeNotify('editor.action.revealDefinition')<CR>
" else
"     " ordinary Neovim
"     " source ~/.vim/vimrc
endif

colorscheme kanagawa
filetype indent on
set diffopt+=vertical
set nostartofline

"search
set ignorecase
set smartcase
set splitbelow
set splitright
set tabstop=2 softtabstop=0
set expandtab
set shiftwidth=2 smarttab
set updatetime=500 " time to show error popup
set listchars=tab:»\ ,trail:·,extends:>,precedes:<


autocmd Filetype mail set spell
autocmd Filetype gitcommit set spell
autocmd Filetype python set textwidth=100
autocmd Filetype rst set textwidth=100
autocmd FileType make setlocal noexpandtab shiftwidth=8 softtabstop=0

" hotkeys
let mapleader = ","
nnoremap <C-F> :Rg<CR>
nnoremap <C-U> :BLines<CR>
cabbrev E Files
nnoremap <leader>1 :lrewind<CR>
nmap <Right> :bnext<CR>
nmap <Left> :bprev<CR>
nnoremap <silent> <C-t> :Neotree filesystem reveal right toggle<CR>
command! CD cd %:p:h | echo "Changed directory to " . getcwd()
vnoremap <Space> zf
nnoremap <nowait> <silent> <Space> :lua vim.lsp.buf.definition()<CR>
nnoremap <nowait> <silent> <leader>t :set list!<CR>


"splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


set laststatus=2
