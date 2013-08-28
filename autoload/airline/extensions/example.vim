" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

" Extension specific variables can be defined the usual fashion.
if !exists('g:airline#extensions#example#number_of_cats')
  let g:airline#extensions#example#number_of_cats = 42
endif

" First we define an init function that will be invoked from extensions.vim
function! airline#extensions#example#init(ext)

  " Here we define a new part for the plugin.  This allows users to place this
  " extension in arbitrary locations.
  let g:airline_parts.cats = '%{airline#extensions#example#get_cats()}'

  " Next up we add a funcref so that we can run some code prior to the
  " statusline getting modifed.
  call a:ext.add_statusline_func('airline#extensions#example#apply')

  " You can also add a funcref for inactive statuslines.
  " call a:ext.add_inactive_statusline_func('airline#extensions#example#unapply')
endfunction

" This function will be invoked just prior to the statusline getting modified.
function! airline#extensions#example#apply(...)
  " First we check for the filetype.
  if &filetype == "nyancat"
    " Let's use a helper function.  It will take care of ensuring that the
    " window-local override exists (and create one based on the global
    " airline_section if not), and prepend to it.
    call airline#extensions#prepend_to_section('x', g:airline_parts.cats)
  endif
endfunction

" Finally, this function will be invoked from the statusline.
function! airline#extensions#example#get_cats()
  let cats = ''
  for i in range(1, g:airline#extensions#example#number_of_cats)
    let cats .= ' (,,,)=(^.^)=(,,,) '
  endfor
  return cats
endfunction

