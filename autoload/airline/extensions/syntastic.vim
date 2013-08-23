" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#syntastic#apply(...)
  let w:airline_section_warning = get(w:, 'airline_section_warning', '')
  let w:airline_section_warning = ' %{SyntasticStatuslineFlag()}'
endfunction

function! airline#extensions#syntastic#init(ext)
  call a:ext.add_statusline_func('airline#extensions#syntastic#apply')
endfunction

