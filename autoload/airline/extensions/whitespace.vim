" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#whitespace#check()
  if line('$') > g:airline_whitespace_max_lines
    return ''
  endif

  let trailing = search(' $', 'nw') != 0
  let mixed = search('^ ', 'nw') != 0 && search('^\t', 'nw') != 0

  if trailing || mixed
    let text = g:airline_whitespace_symbol." "
    if g:airline_detect_whitespace == 1
      if trailing
        let text .= 'trailing '
      endif
      if mixed
        let text .= 'mixed-indent '
      endif
    endif
    return text
  endif
  return ''
endfunction!

function! airline#extensions#whitespace#apply()
  if exists('w:airline_active') && w:airline_active
    let w:airline_section_warning = '%{airline#extensions#whitespace#check()}'
  endif
endfunction

function! airline#extensions#whitespace#init(ext)
  call a:ext.add_statusline_funcref(function('airline#extensions#whitespace#apply'))
endfunction

