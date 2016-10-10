" MIT License. Copyright (c) 2013-2016 Bjorn Neergaard.
" vim: et ts=2 sts=2 sw=2

if !exists('g:loaded_ale')
  finish
endif

let s:error_symbol = get(g:, 'airline#extensions#ale#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#ale#warning_symbol', 'W:')

function! s:count(index)
  let l:buf = bufnr('%')
  let l:count = ale#statusline#Count(l:buf)
  if type(l:count) ==# type(0)
    let l:count = 0
  else
    let l:count = l:count[a:index]
  endif

  return l:count
endfunction

function! airline#extensions#ale#get_errors()
  let l:count = s:count(0)
  return l:count ? s:error_symbol . l:count : ''
endfunction

function! airline#extensions#ale#get_warnings()
  let l:count = s:count(1)
  return l:count ? s:warning_symbol . l:count : ''
endfunction

function! airline#extensions#ale#init(ext)
  call airline#parts#define_function('ale_error_count', 'airline#extensions#ale#get_errors')
  call airline#parts#define_function('ale_warning_count', 'airline#extensions#ale#get_warnings')
endfunction
