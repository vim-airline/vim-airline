" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:symbol = get(g:, 'airline#extensions#readonly#symbol',
      \ get(g:, 'airline_readonly_symbol', get(g:, 'airline_powerline_fonts', 0) ? '' : 'RO'))

function! airline#extensions#readonly#get_mark()
  return &ro ? s:symbol : ''
endfunction

function! airline#extensions#readonly#init()
  let g:airline_section_gutter = ' %#airline_file#%{airline#extensions#readonly#get_mark()} '
        \ .g:airline_section_gutter
endfunction

