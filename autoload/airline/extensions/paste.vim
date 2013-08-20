" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:symbol = get(g:, 'airline#extensions#paste#symbol',
      \ get(g:, 'airline_paste_symbol', (exists('g:airline_powerline_fonts') ? ' ' : '').'PASTE'))

function! airline#extensions#paste#get_mark()
  return &paste ? '  ' . s:symbol : ''
endfunction

function! airline#extensions#paste#init()
  let g:airline_section_a .= '%{airline#extensions#paste#get_mark()}'
endfunction

