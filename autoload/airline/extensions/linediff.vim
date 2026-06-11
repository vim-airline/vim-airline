" MIT License. Copyright (c) 2026 Shad
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#linediff#init(ext)
  call a:ext.add_statusline_func('airline#extensions#linediff#apply')
endfunction

function! airline#extensions#linediff#apply(...)
  if exists('b:differ.description')
    let w:airline_section_c = b:differ.description
  endif
endfunction
