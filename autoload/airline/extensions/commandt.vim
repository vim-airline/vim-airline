" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#commandt#apply_window_override()
  if bufname('%') ==# 'GoToFile'
    call airline#extensions#apply_left_override('CommandT', '')
  endif
endfunction
