" TODO: support loading color palette from g:airline_theme

function! airline#extensions#ctrlp#load_ctrlp_hi()
  hi! CtrlPdark ctermfg=189 ctermbg=55 guifg=#d7d7ff guibg=#5f00af
  hi! CtrlPlight ctermfg=231 ctermbg=98 guifg=#ffffff guibg=#875fd7
  hi! CtrlPwhite ctermfg=55 ctermbg=231 term=bold guifg=#5f00af guibg=#ffffff gui=bold
  hi! CtrlParrow1 ctermfg=98 ctermbg=231 guifg=#875fd7 guibg=#ffffff
  hi! CtrlParrow2 ctermfg=231 ctermbg=98 guifg=#ffffff guibg=#875fd7
  hi! CtrlParrow3 ctermfg=98 ctermbg=55 guifg=#875fd7 guibg=#5f00af
  hi! CtrlParrow4 ctermfg=231 ctermbg=55 guifg=#ffffff guibg=#5f00af
  hi! CtrlParrow5 ctermfg=98 ctermbg=231 guifg=#875fd7 guibg=#ffffff
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
