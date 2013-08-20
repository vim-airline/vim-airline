" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#readonly#get_mark()
  return &ro ? g:airline_readonly_symbol : ''
endfunction

function! airline#extensions#readonly#init()
  let g:airline_section_c .= '%{airline#extensions#readonly#get_mark()}'
endfunction

