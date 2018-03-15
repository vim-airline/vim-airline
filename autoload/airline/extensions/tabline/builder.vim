" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:prototype = {}

function! airline#extensions#tabline#builder#new(context)
  let builder = airline#builder#new(a:context)
  call extend(builder, s:prototype, 'force')
  return builder
endfunction
