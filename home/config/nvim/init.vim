" no vi compatble
set nocompatible
filetype off

syntax on

let mapleader=" "

set backspace=indent,eol,start

set autoindent           " always set autoindenting on
set nobackup             " do not backup
set viminfo=%,'50,\"100,n~/.config/nvim/viminfo
set tags=~/tags,./tags,../tags,../../tags,../../../tags,../../../../tags
set number relativenumber
set ruler                " cursor position
set encoding=utf-8
set wrap                 " visual wrap text
set textwidth=78
" fo, fo-table:
" t: auto-wrap text using tw
" c: auto-wrap comments using tw, auto insert current comment leader
" q: format comments with gq
" r: auto insert current comment leader after <Enter> in INS mode
" n: recognize numbered list
" 1: not break line after one-letter-word
" j: where it makes sense, remove a comment leader when join lines
set formatoptions+=tcqrn1j
set suffixes=.bak,~,.swp,.o,.info,.obj,#

" jump to last position when reopen file
filetype plugin indent on
autocmd FileType mail set tw=70
autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$")
			\| exe "normal g'\"" | endif

set timeoutlen=0

" tab
" set tabstop=8
" set noexpandtab
set smarttab
set copyindent
set cinoptions=:0,l1,g0,N-s,E-s,t0,(0,Ws,j1,J1

" cursor
set cursorline
set scrolloff=3
set matchpairs+=<:>

" rendering
set ttyfast
set lazyredraw
set listchars=tab:>-,eol:$,nbsp:@,extends:#

" folding
set foldenable
set foldlevelstart=5
set foldnestmax=5
set foldmethod=indent
" nnoremap <space> za

" move by visual line
" nnoremap j gj
" nnoremap k gk
set whichwrap=<,>,h,l
" highlight last insert text
nnoremap gV `[v`]

" status
set laststatus=2
set shortmess=at

" Last line
set showmode
set showcmd

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
nnoremap <leader>/ :nohlsearch<CR>

set autowrite
set mouse=nvi
" toggle paste to not alter text on copy/paste
set pastetoggle=<f11>

" http://vim.wikia.com/wiki/GNU/Linux_clipboard_copy/paste_with_xclip
map   <F12> :w !xclip<CR><CR>
vmap  <F12> "*y
map <S-F12> :r!xclip -o<cr>

" trim trailing whitespaces
map  <leader>tr :%s/\s\+$//<cr>
vmap <leader>tr :%s/\s\+$//<cr>
" kill quote spaces (quoting quoted mail)
map  <leader>kqs mz:%s/^> >/>><cr>

" autocomplete
set wildmenu

au! BufEnter *_EDITMSG call setpos('.', [0, 1, 1, 0])
au! BufNewFile,BufRead template setlocal filetype=bash
au! BufRead,BufNewFile */git/t/*.sh setlocal ft=sharness
au  BufNewFile,BufRead *.yml setlocal et ts=2 sts=2 sw=2
au  BufNewFile,BufRead *.yaml setlocal et ts=2 sts=2 sw=2
au  FileType tex setlocal et ts=2 sts=2 sw=2

map <F7> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<cr>
set spellfile=~/.vim/spellfile.add
set sps=best,10

set statusline=[%2.n]        " buffer number
set statusline+=%#todo#%f%*  " filename, relative
set statusline+=%m           " modified [+]
set statusline+=%r           " readonly [RO]
set statusline+=%=           " left/right separator
set statusline+=%h           " [help] flag
set statusline+=%w           " [Preview] flag
set statusline+=%y           " filetype [sh]
set statusline+=[%{&fenc}:   " encoding [utf-8]
set statusline+=%{&ff}]      " line ending [unix/dos]
set statusline+=[%c%V]       " cursor column

" Color scheme
colorscheme mindark

command! -nargs=* HGroup call HGroup(<f-args>)
function! HGroup( ... )
	let l = a:0 > 0 ? a:1 : line('.')
	let c = a:0 > 1 ? a:2 : col('.')
	let s = synID(l, c, 1)
	echo synIDattr(s, 'name') . ' -> ' . synIDattr(synIDtrans(s), 'name')
endfunction

command VKey if &keymap == '' | set keymap=telex |
	\ else | set keymap& | endif
" toggle list
nnoremap <F2> :set list!<cr>
" rotate tab size
nnoremap <silent> <F3> :let &ts=(&ts*2 > 16 ? 2 : &ts*2)<cr>:echo "tabstop:" . &ts<cr>
nnoremap <leader><Left> :bprevious<cr>
nnoremap <leader><Right> :bnext<cr>
if &diff | syntax off | endif
