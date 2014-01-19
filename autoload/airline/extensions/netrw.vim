" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

if !exists(':NetrwSettings')
  finish
endif

function! airline#extensions#netrw#apply(...)
  if &ft == 'netrw'
    call a:1.add_section('airline_a', ' netrw ')
    call a:1.add_section('airline_b', ' %{airline#extensions#branch#get_head()} ')
    call a:1.add_section('airline_c', ' %f ')
    call a:1.split()
    call a:1.add_section('airline_y', ' %{airline#extensions#netrw#sortstring()} ')
    return 1
  endif
endfunction

function! airline#extensions#netrw#init(ext)
  let g:netrw_force_overwrite_statusline = 0
  call a:ext.add_statusline_func('airline#extensions#netrw#apply')
endfunction


function! airline#extensions#netrw#sortstring()
  let order = (g:netrw_sort_direction =~ 'n') ? '+' : '-'
  return g:netrw_sort_by . ' [' . order . ']'
endfunction
