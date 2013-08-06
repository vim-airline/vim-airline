" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#syntastic#apply()
  let w:airline_section_gutter = '%#warningmsg#%{SyntasticStatuslineFlag()}'
endfunction

function! airline#extensions#syntastic#init(ext)
  if g:airline_enable_syntastic && exists('*SyntasticStatuslineFlag')
    call a:ext.add_statusline_funcref(function('airline#extensions#syntastic#apply'))
  endif
endfunction
