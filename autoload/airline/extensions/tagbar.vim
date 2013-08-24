" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

" Arguments: current, sort, fname
function! airline#extensions#tagbar#get_status(...)
  let builder = airline#builder#new({ 'active': a:1 })
  call builder.add_section('airline_a', ' Tagbar ')
  call builder.add_section('airline_b', ' '.a:2.' ')
  call builder.add_section('airline_c', ' '.a:3.' ')
  return builder.build()
endfunction

function! airline#extensions#tagbar#inactive_apply(...)
  if getwinvar(a:2.winnr, '&filetype') == 'tagbar'
    return -1
  endif
endfunction

function! airline#extensions#tagbar#init(ext)
  call a:ext.add_inactive_statusline_func('airline#extensions#tagbar#inactive_apply')
  let g:tagbar_status_func = 'airline#extensions#tagbar#get_status'

  let g:airline_section_x = '%(%{get(w:,"airline_active",0) ? tagbar#currenttag("%s","") : ""} '
        \ .g:airline_right_alt_sep.' %)'.g:airline_section_x
endfunction

