" MIT License. Copyright (c) 2014-2019 Mathias Andersson et al.
" vim: et ts=2 sts=2 sw=2

" Heavily derived from the Gutentags extension

scriptencoding utf-8

if !get(g:, 'loaded_grepper', 0)
  finish
endif

function! airline#extensions#grepper#status()
  let msg = grepper#statusline()
  return empty(msg) ? '' : 'grepper'
endfunction

function! airline#extensions#grepper#init(ext)
  call airline#parts#define_function('grepper', 'airline#extensions#grepper#status')
endfunction
