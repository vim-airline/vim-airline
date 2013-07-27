function! airline#extensions#ctrlp#load_theme()
  if exists('g:airline#themes#{g:airline_theme}#ctrlp')
    let theme = g:airline#themes#{g:airline_theme}#ctrlp
  else
    let theme = {
          \ 'CtrlPdark'   : [ '#d7d7ff' , '#5f00af' , 189 , 55  , ''     ] ,
          \ 'CtrlPlight'  : [ '#ffffff' , '#875fd7' , 231 , 98  , ''     ] ,
          \ 'CtrlPwhite'  : [ '#5f00af' , '#ffffff' , 55  , 231 , 'bold' ] ,
          \ 'CtrlParrow1' : [ '#875fd7' , '#ffffff' , 98  , 231 , ''     ] ,
          \ 'CtrlParrow2' : [ '#ffffff' , '#875fd7' , 231 , 98  , ''     ] ,
          \ 'CtrlParrow3' : [ '#875fd7' , '#5f00af' , 98  , 55  , ''     ] ,
          \ 'CtrlParrow4' : [ '#ffffff' , '#5f00af' , 231 , 55  , ''     ] ,
          \ 'CtrlParrow5' : [ '#875fd7' , '#ffffff' , 98  , 231 , ''     ] ,
          \ }
  endif
  for key in keys(theme)
    call airline#exec_highlight(key, theme[key])
  endfor
endfunction

" Recreate Ctrl-P status line with some slight modifications

" Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
" a:1 a:2 a:3 a:4 a:5 a:6 a:7
function! airline#extensions#ctrlp#ctrlp_airline(...)
  let regex = a:3 ? '%#CtrlPlight#  regex %*' : ''
  let prv = '%#CtrlPlight# '.a:4.' %#Ctrlparrow1#'.g:airline_left_sep
  let item = '%#CtrlPwhite# '.a:5.' %#CtrlParrow2#'.g:airline_left_sep
  let nxt = '%#CtrlPlight# '.a:6.' %#CtrlParrow3#'.g:airline_left_sep
  let marked = '%#CtrlPdark# '.a:7.' '
  let focus = '%=%<%#CtrlPdark# '.a:1.' %*'
  let byfname = '%#CtrlParrow4#'.g:airline_right_alt_sep.'%#CtrlPdark# '.a:2.' %*'
  let dir = '%#CtrlParrow3#'.g:airline_right_sep.'%#CtrlPlight# '.getcwd().' %*'
  " Return the full statusline
  return regex.prv.item.nxt.marked.focus.byfname.dir
endfunction

" Argument: len
" a:1
function! airline#extensions#ctrlp#ctrlp_airline_status(...)
  let len = '%#CtrlPwhite# '.a:1
  let dir = '%=%<%#CtrlParrow5#'.g:airline_right_sep.'%#CtrlPlight# '.getcwd().' %*'
  " Return the full statusline
  return len.dir
endfunction
