" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#iminsert#get_text()
  if &iminsert
    return toupper(get(b:, 'keymap_name', 'lang'))
  endif
  return ''
endfunction

function! airline#extensions#iminsert#init()
  let g:airline_section_a .= ' '.g:airline_left_alt_sep.' %{airline#extensions#iminsert#get_text()}'
endfunction

