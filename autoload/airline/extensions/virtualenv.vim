" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#virtualenv#init(ext)
  call a:ext.add_statusline_func('airline#extensions#virtualenv#apply')
endfunction

function! airline#extensions#virtualenv#apply(...)
  if &filetype == "python"
    call airline#extensions#append_to_section('x', ' '.g:airline_right_alt_sep.' %{virtualenv#statusline()}')
  endif
endfunction

