" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#fragments#get_paste()
  return g:airline_detect_paste && &paste ? '  '.g:airline_symbols.paste : ''
endfunction

function! airline#fragments#get_iminsert()
  if g:airline_detect_iminsert && &iminsert && exists('b:keymap_name')
    return '  '.g:airline_left_alt_sep.' '.toupper(b:keymap_name)
  endif
  return ''
endfunction

function! airline#fragments#get_readonly()
  return &readonly ? g:airline_symbols.readonly : ''
endfunction

