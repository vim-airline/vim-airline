" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

" Extension specific variables can be defined the usual fashion.
if !exists('g:airline#extensions#example#number_of_cats')
  let g:airline#extensions#example#number_of_cats = 42
endif

" First you should follow the convention and define an 'init' function.
" It takes a single argument, which is the 'ext'ension manager of sorts,
" which you can invoke certain functions.  The most important one is
" 'add_statusline_func', which as the name implies, adds a function to
" the collection such that it will be invoked prior to changes being made
" to the statusline. Finally, invoke this init function in the
" 'extensions.vim' file after a check to a non-autoloaded variable,
" command, or function.
function! airline#extensions#example#init(ext)
  call a:ext.add_statusline_func('airline#extensions#example#apply')

  " Alternatively, you can also modify the default global section by
  " appending or prepending to it.  But read on to see why using the funcref
  " method is preferred.
  let g:airline_section_y .= '%{airline#extensions#example#nyancat()}'
endfunction

function! airline#extensions#example#apply(...)
  " Here we are checking for the filetype, allowing for the extension to
  " be loaded only in certain cases.
  if &filetype == "nyancat"

    " Then we define a window-local variable, which overrides the default
    " g: variable.
    let w:airline_section_gutter =
          \ g:airline_section_gutter
          \ .' %{airline#extensions#example#get_cats()}'
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

