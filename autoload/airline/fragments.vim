" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let g:airline#fragments#symbols = get(g:, 'airline#fragments#symbols', {})
call extend(g:airline#fragments#symbols, {
      \ 'paste': get(g:, 'airline_paste_symbol', g:airline_left_alt_sep.' PASTE')
      \ }, 'keep')

function! airline#fragments#get_paste()
  return &paste ? '  ' . g:airline#fragments#symbols.paste : ''
endfunction

