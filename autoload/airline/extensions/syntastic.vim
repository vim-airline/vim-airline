" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#syntastic#init(ext)
  if g:airline_section_gutter == ''
    let g:airline_section_gutter = '%#warningmsg#%{SyntasticStatuslineFlag()}'
  endif
endfunction
