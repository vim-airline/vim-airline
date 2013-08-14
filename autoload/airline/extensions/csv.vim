" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

if !exists('g:airline#extensions#csv#column_display')
  let g:airline#extensions#csv#column_display = 'Number'
endif

function! airline#extensions#csv#apply()
  if &ft ==# "csv" && exists("*CSV_WCol")
    if get(g:, 'airline#extensions#csv#column_display', '') ==# 'Name'
      let column = '['.CSV_WCol('Name').CSV_WCol().']'
    else
      let column = '['.CSV_WCol().']'
    endif

    if !exists('w:airline_section_gutter')
      let w:airline_section_gutter = ''
    endif
    let w:airline_section_gutter .= g:airline_left_alt_sep.' '.column
  endif
endfunction

function! airline#extensions#csv#init(ext)
  call a:ext.add_statusline_funcref(function('airline#extensions#csv#apply'))
endfunction

