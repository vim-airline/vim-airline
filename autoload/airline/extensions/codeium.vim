" MIT License. Copyright (c) 2014-2021 Mathias Andersson et al.
" Plugin: https://github.com/Exafunction/codeium.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_codeium', 0)
  finish
endif

function! airline#extensions#codeium#status() abort
  return '{…}' . codeium#GetStatusString()
endfunction

function! airline#extensions#codeium#init(ext) abort
  call airline#parts#define_function('codeium', 'airline#extensions#codeium#status')
endfunction
