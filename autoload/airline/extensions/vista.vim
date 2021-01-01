" MIT License. Copyright (c) 2021 s1341 (github@shmarya.net)
" Plugin: https://github.com/liuchengxu/vista.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8
if !get(g:, 'loaded_vista', 0)
  finish
endif

function! airline#extensions#vista#currenttag() abort
  if get(w:, 'airline_active', 0)
    return airline#util#shorten(get(b:, 'vista_nearest_method_or_function', ''), 91, 9)
  endif
endfunction

function! airline#extensions#vista#init(ext) abort
  call airline#parts#define_function('vista', 'airline#extensions#vista#currenttag')
endfunction
