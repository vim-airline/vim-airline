" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#whitespace#check()
  let w:airline_section_warning = '%{get(w:, "airline_active", 0) && search(" $", "nw")'
        \ .'? " ".g:airline_whitespace_symbol." " : ""}'
endfunction

function! airline#extensions#whitespace#init(ext)
  call a:ext.add_statusline_funcref(function('airline#extensions#whitespace#check'))
endfunction
