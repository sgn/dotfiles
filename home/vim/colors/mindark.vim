"=============================================================================
"
" mindark.vim
"
" A minimalist dark color scheme.
"
" This file does not define the colors.  This, rather, gets the ANSI colors in
" a good arrangement to be used with the TTY's scheme.
"
"  0 black              (unmapped)
"  1 red                (unmapped)
"  2 green              (unmapped)
"  3 yellow             (unmapped)
"  4 blue               type identifiers
"  5 magenta            (unmapped)
"  6 cyan               string literals
"  7 white              normal text foreground
"  8 bblack             (unmapped)
"  9 bred               (unmapped)
" 10 bgreen             comments
" 11 byellow            (unmapped)
" 12 bblue              (unmapped)
" 13 bmagenta           (unmapped)
" 14 bcyan              (unmapped)
" 15 bwhite             highlighted/special foreground
"
"=============================================================================

"-----------------------------------------------------------------------------
" Colorscheme Boilerplate
"-----------------------------------------------------------------------------

" This is a dark scheme.
set background=dark

" Drop current highlighting.
highlight clear

" Reset highlighting to the defaults.
if exists( 'syntax_on' )
    syntax reset
endif

" Set the name of the scheme.
let g:colors_name = 'mindark'

"-----------------------------------------------------------------------------
" Editor Display
"-----------------------------------------------------------------------------

" Normal Text (everything that isn't "highlighted", must be first in scheme)
hi Normal           cterm=none      ctermbg=none    ctermfg=7

" Cursor and Selection
hi Cursor           cterm=none      ctermbg=none    ctermfg=11
hi CursorColumn     cterm=none      ctermbg=none    ctermfg=none
hi CursorLine       cterm=none      ctermbg=8       ctermfg=none
hi Visual           cterm=none      ctermbg=8       ctermfg=none

" Window Margins
hi ColorColumn      cterm=none      ctermbg=none       ctermfg=none
hi CursorLineNr     cterm=none      ctermbg=none       ctermfg=8
hi LineNr           cterm=none      ctermbg=none       ctermfg=8
hi VertSplit        cterm=none      ctermbg=none       ctermfg=8

"-----------------------------------------------------------------------------
" In-buffer Highlighting
"-----------------------------------------------------------------------------

" Other
hi Underlined       cterm=underline

"-----------------------------------------------------------------------------
" Informational Highlighting
"-----------------------------------------------------------------------------

" Errors and Debugging
hi Error            cterm=underline      ctermbg=8      ctermfg=1

"-----------------------------------------------------------------------------
" Code Syntax Highlighting
"-----------------------------------------------------------------------------

" Highlight other delimiters the same as parenthesis.
hi link Delimiter Parens

" Comments
hi Comment          cterm=none      ctermbg=none    ctermfg=2

" Constants
hi Constant         cterm=none      ctermbg=none    ctermfg=15
hi String           cterm=none      ctermbg=none    ctermfg=6

" Highlight other constants similarly.
hi link Boolean Constant
hi link Character Constant
hi link Float Constant
hi link Number Constant

" Include the quotation marks when highlighting string constants.
hi link StringDelimiter String

" Named Identifiers
hi Function         cterm=none      ctermbg=none    ctermfg=15
hi Identifier       cterm=none      ctermbg=none    ctermfg=15

" Language Constructs
hi Operator         cterm=none      ctermbg=none    ctermfg=15
hi Statement        cterm=none      ctermbg=none    ctermfg=15

" Preprocessor
hi PreProc          cterm=none      ctermbg=none    ctermfg=15

" Types
hi Type             cterm=none      ctermbg=none    ctermfg=15

hi Title            cterm=none      ctermbg=none    ctermfg=6
hi Special          cterm=none      ctermbg=none    ctermfg=5

" Diff
hi DiffAdd          cterm=none      ctermbg=none    ctermfg=2
hi DiffAdded        cterm=none      ctermbg=none    ctermfg=2
hi DiffDelete       cterm=none      ctermbg=none    ctermfg=1
hi DiffRemoved      cterm=none      ctermbg=none    ctermfg=1
hi DiffLine         cterm=none      ctermbg=none    ctermfg=6
hi DiffFile         cterm=bold      ctermbg=none    ctermfg=15
hi DiffNewFile      cterm=bold      ctermbg=none    ctermfg=15
hi DiffIndexLine    cterm=bold      ctermbg=none    ctermfg=15
hi DiffText         cterm=bold      ctermbg=none    ctermfg=3
hi DiffChange       cterm=none      ctermbg=none    ctermfg=5

" git
hi gitcommitSummary cterm=none      ctermbg=none    ctermfg=6
hi gitrebaseReword  cterm=none      ctermbg=none    ctermfg=6
hi gitrebaseEdit    cterm=none      ctermbg=none    ctermfg=6
hi gitrebaseBreak   cterm=none      ctermbg=none    ctermfg=6
hi gitrebaseExec    cterm=none      ctermbg=none    ctermfg=3
hi gitrebaseSquash  cterm=none      ctermbg=none    ctermfg=5
hi gitrebaseFixup   cterm=none      ctermbg=none    ctermfg=5
hi gitrebaseMerge   cterm=none      ctermbg=none    ctermfg=3
hi gitrebaseLabel   cterm=none      ctermbg=none    ctermfg=4
hi gitrebaseReset   cterm=none      ctermbg=none    ctermfg=4
hi gitrebaseNoop    cterm=none      ctermbg=none    ctermfg=8
hi gitrebaseDrop    cterm=none      ctermbg=none    ctermfg=8
