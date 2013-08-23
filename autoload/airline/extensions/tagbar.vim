" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#tagbar#apply(...)
  if &ft == 'tagbar'
    call airline#extensions#apply_left_override('Tagbar', '%{TagbarGenerateStatusline()}')
  endif
endfunction

function! s:check_statusline()
  " this is a hack!! unlike most plugins that set eventignore=all, tagbar only
  " sets it to BufEnter, so the ordering is off: airline sets the statusline
  " first, and then tagbar overwrites it, so this detects that and changes it
  " back to the airline statusline.
  if exists('#airline') && match(&statusline, '^%!Tagbar') >= 0
    call airline#update_statusline()
  endif
endfunction

function! airline#extensions#tagbar#init(ext)
  call a:ext.add_statusline_func('airline#extensions#tagbar#apply')

  let g:airline_section_x = '%(%{get(w:,"airline_active",0) ? tagbar#currenttag("%s","") : ""} '
        \ .g:airline_right_alt_sep.' %)'.g:airline_section_x

  augroup airline_tagbar
    autocmd!
    autocmd CursorMoved * call <sid>check_statusline()
  augroup END
endfunction

