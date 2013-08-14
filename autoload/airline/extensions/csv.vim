" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

if !exists('g:airline#extensions#csv#column_display')
  let g:airline#extensions#csv#column_display = 'Number'
endif

function! airline#extensions#csv#get_statusline()
  if exists('*CSV_WCol')
    if g:airline#extensions#csv#column_display ==# 'Name'
      return '['.CSV_WCol('Name').CSV_WCol().']'
    else
      return '['.CSV_WCol().']'
    endif
  endif
  return ''
endfunction

function! airline#extensions#csv#apply()
  if &ft ==# "csv"
    if !exists('w:airline_section_gutter')
      let w:airline_section_gutter = '%='
    endif
    let w:airline_section_gutter =
          \ g:airline_left_alt_sep
          \ .' %{airline#extensions#csv#get_statusline()}'
          \ .w:airline_section_gutter
  endif
endfunction

function! airline#extensions#csv#init(ext)
  call a:ext.add_statusline_funcref(function('airline#extensions#csv#apply'))
endfunction

