" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

" Extension specific variables can be defined the usual fashion.
if !exists('g:airline#extensions#example#number_of_cats')
  let g:airline#extensions#example#number_of_cats = 42
endif

" There are predominantly two methods for integrating a plugin into
" vim-airline.  The first method here simply modifies the global section and
" appends information to it.  This is useful for cases where the information
" should be displayed all the time for all filetypes.
function! airline#extensions#example#init(ext)
  let g:airline_section_y .= '%{airline#extensions#example#get_cats()}'
endfunction

" The second method involves using the 'ext'ension manager that was passed in
" and appends a name of a function.  This function will be invoked just prior
" to updating the statusline.  This method is useful for plugin-specific
" statuslines (like NERDTree or Tagbar) or language specific plugins (like
" virtualenv) which do not need to be loaded all the time.
function! airline#extensions#example#init(ext)
  call a:ext.add_statusline_func('airline#extensions#example#apply')

  " There is also the following function for making changes just prior to an
  " inactive statusline.
  " call a:ext.add_inactive_statusline_func('airline#extensions#example#unapply')
endfunction

" This function will be invoked just prior to the statusline getting modified.
function! airline#extensions#example#apply(...)
  " First we check for the filetype.
  if &filetype == "nyancat"
    " Let's use a helper function.  It will take care of ensuring that the
    " window-local override exists (and create one based on the global
    " airline_section if not), and prepend to it.
    call airline#extensions#prepend_to_section('x', '%{airline#extensions#example#get_cats()} ')
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

