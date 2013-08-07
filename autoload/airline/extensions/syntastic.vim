" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#syntastic#apply()
  if exists('w:airline_active') && w:airline_active
    let w:airline_section_warning = ' %#warningmsg#%{SyntasticStatuslineFlag()}'
  endif
endfunction

function! airline#extensions#syntastic#init(ext)
  call a:ext.add_statusline_funcref(function('airline#extensions#syntastic#apply'))
endfunction
