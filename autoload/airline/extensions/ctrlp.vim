" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:color_template = get(g:, 'airline#extensions#ctrlp#color_template', 'insert')

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
  if exists('g:airline#themes#{g:airline_theme}#palette.ctrlp')
    let theme = g:airline#themes#{g:airline_theme}#palette.ctrlp
  else
    let s:color_template = has_key(g:airline#themes#{g:airline_theme}#palette, s:color_template) ? s:color_template : 'insert'
    let theme = airline#extensions#ctrlp#generate_color_map(
          \ g:airline#themes#{g:airline_theme}#palette[s:color_template]['airline_c'],
          \ g:airline#themes#{g:airline_theme}#palette[s:color_template]['airline_b'],
          \ g:airline#themes#{g:airline_theme}#palette[s:color_template]['airline_a'])
  endif
  for key in keys(theme)
    call airline#highlighter#exec(key, theme[key])
  endfor
endfunction

" Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
function! airline#extensions#ctrlp#ctrlp_airline(...)
  let regex = a:3 ? '%#CtrlPlight#  regex %*' : ''
  let prv = '%#CtrlPlight# '.a:4.' %#Ctrlparrow1#'.g:airline_left_sep
  let item = '%#CtrlPwhite# '.a:5.' %#CtrlParrow2#'.g:airline_left_sep
  let nxt = '%#CtrlPlight# '.a:6.' %#CtrlParrow3#'.g:airline_left_sep
  let marked = '%#CtrlPdark# '.a:7.' '
  let focus = '%=%<%#CtrlPdark# '.a:1.' %*'
  let byfname = '%#CtrlParrow3#'.g:airline_right_alt_sep.'%#CtrlPdark# '.a:2.' %*'
  let dir = '%#CtrlParrow3#'.g:airline_right_sep.'%#CtrlPlight# '.getcwd().' %*'
  return regex.prv.item.nxt.marked.focus.byfname.dir
endfunction

" Argument: len
function! airline#extensions#ctrlp#ctrlp_airline_status(...)
  let len = '%#CtrlPdark# '.a:1
  let dir = '%=%<%#CtrlParrow3#'.g:airline_right_sep.'%#CtrlPlight# '.getcwd().' %*'
  return len.dir
endfunction

function! airline#extensions#ctrlp#apply(...)
  " disable statusline overwrite if ctrlp already did it
  return match(&statusline, 'CtrlPlight') >= 0 ? -1 : 0
endfunction

function! airline#extensions#ctrlp#init(ext)
  let g:ctrlp_status_func = {
        \ 'main': 'airline#extensions#ctrlp#ctrlp_airline',
        \ 'prog': 'airline#extensions#ctrlp#ctrlp_airline_status',
        \ }
  call a:ext.add_statusline_func('airline#extensions#ctrlp#apply')
endfunction

