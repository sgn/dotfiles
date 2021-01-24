if !exists('g:lsp_loaded')
    finish
endif
function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal signcolumn=yes
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> gs <plug>(lsp-document-symbol-search)
	nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
	nmap <buffer> gr <plug>(lsp-references)
	nmap <buffer> gi <plug>(lsp-implementation)
	nmap <buffer> gt <plug>(lsp-type-definition)
	nmap <buffer> <leader>rn <plug>(lsp-rename)
	nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
	nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
	nmap <buffer> K <plug>(lsp-hover)

	let g:lsp_format_sync_timeout = 1000

	" refer to doc to add more commands
endfunction

if executable('gopls')
	au User lsp_setup call lsp#register_server({
				\ 'name': 'gopls',
				\ 'cmd': {server_info->['gopls']},
				\ 'allowlist': ['go'],
				\ })
endif

augroup lsp_install
	au!
	" call s:on_lsp_buffer_enabled
	" only for languages that has the server registered.
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
