" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#bufferline#init(ext)
  highlight bufferline_selected gui=bold cterm=bold term=bold
  highlight link bufferline_selected_inactive airline_c_inactive
  let g:bufferline_inactive_highlight = 'airline_c'
  let g:bufferline_active_highlight = 'bufferline_selected'
  let g:bufferline_active_buffer_left = ''
  let g:bufferline_active_buffer_right = ''
  let g:bufferline_separator = ' '

  if g:airline_section_c == '%f%m'
    let g:airline_section_c = '%{bufferline#refresh_status()}'.bufferline#get_status_string()
  endif
endfunction
