" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#tagbar#apply()
  if &ft == 'tagbar'
    call airline#extensions#apply_left_override('Tagbar', '%{TagbarGenerateStatusline()}')
  endif
endfunction

function! airline#extensions#tagbar#init(ext)
  call a:ext.add_statusline_funcref(function('airline#extensions#tagbar#apply'))

  let g:airline_section_x = '%(%{w:airline_active ? tagbar#currenttag("%s","") : ""} '
        \ .g:airline_right_alt_sep.' %)'.g:airline_section_x
endfunction

