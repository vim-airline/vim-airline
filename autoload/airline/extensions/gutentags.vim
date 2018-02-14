" MIT License. Copyright (c) 2014-2018 Mathias Andersson et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_gutentags', 0)
  finish
endif

function! airline#extensions#gutentags#status()
  return gutentags#statusline() =~# '^TAGS' ? 'Gen. tags' : ''
endfunction

function! airline#extensions#gutentags#init(ext)
  call airline#parts#define_function('gutentags', 'airline#extensions#gutentags#status')
endfunction
