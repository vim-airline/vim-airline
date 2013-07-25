function! airline#extensions#commandt#apply_window_override()
  if bufname('%') ==# 'GoToFile'
    call airline#extensions#apply_left_override('CommandT', '')
  endif
endfunction
