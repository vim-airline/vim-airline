" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#bufferline#apply()
  let w:airline_section_c = '%{bufferline#refresh_status()}'.bufferline#get_status_string()
endfunction

function! airline#extensions#bufferline#init(ext)
  highlight AlBl_active gui=bold cterm=bold term=bold
  highlight link AlBl_inactive Al6
  let g:bufferline_inactive_highlight = 'AlBl_inactive'
  let g:bufferline_active_highlight = 'AlBl_active'
  let g:bufferline_active_buffer_left = ''
  let g:bufferline_active_buffer_right = ''
  let g:bufferline_separator = ' '

  call a:ext.add_statusline_funcref(function('airline#extensions#bufferline#apply'))
endfunction
