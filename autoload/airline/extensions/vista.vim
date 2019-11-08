" MIT License. Copyright (c) 2019 s1341 (github@shmarya.net)
" Plugin: https://github.com/liuchngxu/vista.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#vista#currenttag()
  if get(w:, 'airline_active', 0)
    return get(b:, 'vista_nearest_method_or_function', '')
  endif
endfunction

function! airline#extensions#vista#init(ext)
  call airline#parts#define_function('vista', 'airline#extensions#vista#currenttag')
endfunction
