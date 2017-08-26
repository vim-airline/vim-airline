" MIT License. Copyright (c) 2017 Doron Behar.

scriptencoding utf-8

if !has('keymap')
	finish
endif

function! airline#extensions#keymap#status()
	if &keymap != ''
		let s:keymap2print = g:airline_symbols.keymap . ' ' . &keymap
	else
		let s:keymap2print = ''
	endif
	return printf('%s', s:keymap2print)
endfunction

function! airline#extensions#keymap#init(ext)
  call airline#parts#define_function('keymap', 'airline#extensions#keymap#status')
endfunction
