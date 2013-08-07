" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html

function! airline#extensions#whitespace#check()
  if &readonly
    return ''
  endif

  if !exists('b:airline_whitespace_check')
    let b:airline_whitespace_check = ''
    let trailing = search(' $', 'nw')
    let mixed = search('^ ', 'nw') != 0 && search('^\t', 'nw') != 0

    if trailing != 0 || mixed
      let b:airline_whitespace_check = g:airline_whitespace_symbol." "
      if g:airline_detect_whitespace == 1
        if trailing != 0
          let b:airline_whitespace_check .= 'trailing['.trailing.'] '
        endif
        if mixed
          let b:airline_whitespace_check .= 'mixed-indent '
        endif
      endif
    endif
  endif
  return b:airline_whitespace_check
endfunction!

function! airline#extensions#whitespace#apply()
  if exists('w:airline_active') && w:airline_active
    if !exists('w:airline_section_warning')
      let w:airline_section_warning = ' '
    endif
    let w:airline_section_warning .= '%{airline#extensions#whitespace#check()}'
  endif
endfunction

function! airline#extensions#whitespace#init(ext)
  call a:ext.add_statusline_funcref(function('airline#extensions#whitespace#apply'))

  augroup airline_whitespace
    autocmd!
    autocmd CursorHold,BufWritePost * unlet! b:airline_whitespace_check
  augroup END
endfunction

