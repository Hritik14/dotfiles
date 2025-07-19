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
set tabstop=4
set shiftwidth=4


autocmd Filetype mail set spell
autocmd Filetype gitcommit set spell
autocmd Filetype python set textwidth=100
autocmd Filetype rst set textwidth=100

" hotkeys
nnoremap <C-F> :BLines<CR>
nnoremap <C-U> :Lines<CR>
cabbrev E Files
nnoremap <C-b> :lbefore<CR>
nnoremap <C-n> :lafter<CR>
nnoremap <leader>1 :lrewind<CR>
nnoremap gb :Buffers<CR>
nmap <Right> :bnext<CR>
nmap <Left> :bprev<CR>
nnoremap <silent> <C-t> :Neotree filesystem reveal right toggle<CR>
command! CD cd %:p:h | echo "Changed directory to " . getcwd()
vnoremap <Space> zf
nnoremap <nowait> <Space> gd


"splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


:set laststatus=2
:set statusline=%m\ %t\ %y\ %{&fileencoding?&fileencoding:&encoding}\ %=%(C:%c\ L:%l\ %P%)
