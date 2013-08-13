" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#csv#get_statusline()
  if &ft ==# "csv" && exists("*CSV_WCol")
    if exists("g:airline_filetype_csv") && g:airline_filetype_csv ==# 'Name'
      return '['.CSV_WCol('Name').CSV_WCol().']'
    else
      return '['.CSV_WCol().']'
    endif
  else
    return ''
  endif
endfunction

function! airline#extensions#csv#init(ext)
  call a:ext.add_statusline_funcref(function('airline#extensions#csv#get_statusline'))
  let g:airline_section_c .= ' '.g:airline_left_alt_sep.' %{airline#extensions#csv#get_statusline()}'
endfunction

