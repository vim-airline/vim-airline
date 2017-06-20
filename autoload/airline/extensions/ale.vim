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

function! airline#extensions#ale#get_warning()
  return airline#extensions#ale#get('warning')
endfunction

function! airline#extensions#ale#get_error()
  return airline#extensions#ale#get('error')
endfunction

function! airline#extensions#ale#get(type)
  let is_err = a:type is# 'error'
  let cnt = s:count(is_err)
  if cnt == 0
    return ''
  else
    return (is_err ? s:error_symbol : s:warning_symbol) . cnt
  endif
endfunction

function! airline#extensions#ale#init(ext)
  call airline#parts#define_function('ale_error_count', 'airline#extensions#ale#get_error')
  call airline#parts#define_function('ale_warning_count', 'airline#extensions#ale#get_warning')
endfunction
