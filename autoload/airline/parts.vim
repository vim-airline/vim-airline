" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#parts#append(name)
  let val = function(a:name)()
  return empty(val) ? '' : '  '.g:airline_left_alt_sep.' '.val
endfunction

function! airline#parts#prepend(name)
  let val = function(a:name)()
  return empty(val) ? '' : val.' '.g:airline_right_alt_sep
endfunction

function! airline#parts#empty()
  return ''
endfunction

function! airline#parts#mode()
  return get(w:, 'airline_current_mode', '')
endfunction

function! airline#parts#paste()
  return g:airline_detect_paste && &paste ? g:airline_symbols.paste : ''
endfunction

function! airline#parts#iminsert()
  if g:airline_detect_iminsert && &iminsert && exists('b:keymap_name')
    return toupper(b:keymap_name)
  endif
  return ''
endfunction

function! airline#parts#readonly()
  return &readonly ? g:airline_symbols.readonly : ''
endfunction

