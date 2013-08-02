" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#ctrlp#generate_color_map(dark, light, white)
  return {
        \ 'CtrlPdark'   : a:dark,
        \ 'CtrlPlight'  : a:light,
        \ 'CtrlPwhite'  : a:white,
        \ 'CtrlParrow1' : [ a:light[1] , a:white[1] , a:light[3] , a:white[3] , ''     ] ,
        \ 'CtrlParrow2' : [ a:white[1] , a:light[1] , a:white[3] , a:light[3] , ''     ] ,
        \ 'CtrlParrow3' : [ a:light[1] , a:dark[1]  , a:light[3] , a:dark[3]  , ''     ] ,
        \ }
endfunction

function! airline#extensions#ctrlp#load_theme()
  if exists('g:airline#themes#{g:airline_theme}#ctrlp')
    let theme = g:airline#themes#{g:airline_theme}#ctrlp
  else
    let theme = airline#extensions#ctrlp#generate_color_map(
          \ [ '#d7d7ff' , '#5f00af' , 189 , 55  , ''     ],
          \ [ '#ffffff' , '#875fd7' , 231 , 98  , ''     ],
          \ [ '#5f00af' , '#ffffff' , 55  , 231 , 'bold' ])
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
  let byfname = '%#CtrlParrow3#'.g:airline_right_alt_sep.'%#CtrlPdark# '.a:2.' %*'
  let dir = '%#CtrlParrow3#'.g:airline_right_sep.'%#CtrlPlight# '.getcwd().' %*'
  " Return the full statusline
  return regex.prv.item.nxt.marked.focus.byfname.dir
endfunction

" Argument: len
" a:1
function! airline#extensions#ctrlp#ctrlp_airline_status(...)
  let len = '%#CtrlPdark# '.a:1
  let dir = '%=%<%#CtrlParrow3#'.g:airline_right_sep.'%#CtrlPlight# '.getcwd().' %*'
  " Return the full statusline
  return len.dir
endfunction
