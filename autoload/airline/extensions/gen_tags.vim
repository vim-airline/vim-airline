" MIT License. Copyright (c) 2014-2020 Mathias Andersson et al.
" Written by Kamil Cukrowski 2020
" Plugin: https://github.com/jsfaint/gen_tags.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !(get(g:, 'loaded_gentags#gtags', 0) || get(g:, 'loaded_gentags#ctags', 0))
  finish
endif

function! airline#extensions#gen_tags#status(...) abort
  return gen_tags#job#is_running() != 0 ? 'Gen. gen_tags' : ''
endfunction

function! airline#extensions#gen_tags#init(ext) abort
  call airline#parts#define_function('gen_tags', 'airline#extensions#gen_tags#status')
endfunction

