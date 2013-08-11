" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#syntastic#apply()
  let w:airline_section_warning = ' %#warningmsg#%{SyntasticStatuslineFlag()}'
endfunction

function! airline#extensions#syntastic#init(ext)
  call a:ext.add_statusline_funcref(function('airline#extensions#syntastic#apply'))
endfunction
