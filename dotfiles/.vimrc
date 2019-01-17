" no vi compatble
set nocompatible
filetype off

syntax on

filetype plugin indent on
let mapleader = ","

set modelines=0
set number
set ruler
set visualbell
set encoding=utf-8
set wrap
set textwidth=78
set formatoptions=tcqrn1

" tab
set tabstop=8
set shiftwidth=8
set noexpandtab

" cursor
set scrolloff=3
set matchpairs+=<:>

" rendering
set ttyfast

" status
set laststatus=2

" Last line
set showmode
set showcmd

" Search

set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" Color scheme
let base16colorspace=256
colorscheme base16-gruvbox-dark-hard
