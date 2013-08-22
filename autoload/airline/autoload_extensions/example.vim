" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

" Extension specific variables can be defined the usual fashion.
if !exists('g:airline#autoload_extensions#example#number_of_cats')
  let g:airline#autoload_extensions#example#number_of_cats = 42
endif


function! airline#autoload_extensions#example#init()
"   call a:ext.add_statusline_funcref(function('airline#extensions#example#apply'))
"   let g:airline_section_y .= '%{airline#autoload_extensions#example#get_cats()}'
endfunction

function! airline#autoload_extensions#example#apply()
  " Here we are checking for the filetype, allowing for the extension to
  " be loaded only in certain cases.
  if &filetype == "nyancat"

    " Then we define a window-local variable, which overrides the default
    " g: variable.
    let w:airline_section_gutter =
          \ g:airline_section_gutter
          \ .' %{airline#autoload_extensions#example#get_cats()}'
  endif
endfunction

" Finally, this function will be invoked from the statusline.
function! airline#autoload_extensions#example#get_cats()
  let cats = ''
  for i in range(1, g:airline#autoload_extensions#example#number_of_cats)
    let cats .= ' (,,,)=(^.^)=(,,,) '
  endfor
  return cats
endfunction

