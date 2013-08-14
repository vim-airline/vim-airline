" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

" generates a dictionary which defines the colors for each highlight group
function! airline#themes#generate_color_map(section1, section2, section3, file)
  " provide matching background colors if not provided
  let file = copy(a:file)
  if file[1] == '' | let file[1] = a:section3[1] | endif
  if file[3] == '' | let file[3] = a:section3[3] | endif

  "                         guifg           guibg           ctermfg         ctermbg         gui/term
  return {
      \ 'mode':           [ a:section1[0] , a:section1[1] , a:section1[2] , a:section1[3] , get(a:section1, 4, 'bold') ] ,
      \ 'mode_separator': [ a:section1[1] , a:section2[1] , a:section1[3] , a:section2[3] , ''                         ] ,
      \ 'info':           [ a:section2[0] , a:section2[1] , a:section2[2] , a:section2[3] , get(a:section2, 4, ''    ) ] ,
      \ 'info_separator': [ a:section2[1] , a:section3[1] , a:section2[3] , a:section3[3] , ''                         ] ,
      \ 'statusline':     [ a:section3[0] , a:section3[1] , a:section3[2] , a:section3[3] , get(a:section3 , 4 , ''    ) ] ,
      \ 'file':           [ file[0]       , file[1]       , file[2]       , file[3]       , get(file       , 4 , ''    ) ] ,
      \ }
endfunction

function! s:get_syn(group, what)
  " need to pass in mode, known to break on 7.3.547
  let mode = has('gui_running') ? 'gui' : 'cterm'
  let color = synIDattr(synIDtrans(hlID(a:group)), a:what, mode)
  if empty(color) || color == -1
    let color = synIDattr(synIDtrans(hlID('Normal')), a:what, mode)
  endif
  if empty(color) || color == -1
    if has('gui_running')
      let color = a:what ==# 'fg' ? '#000000' : '#FFFFFF'
    else
      let color = a:what ==# 'fg' ? 0 : 1
    endif
  endif
  return color
endfunction

function! s:get_array(fg, bg, opts)
  let fg = a:fg
  let bg = a:bg
  return has('gui_running')
        \ ? [ fg, bg, '', '', join(a:opts, ',') ]
        \ : [ '', '', fg, bg, join(a:opts, ',') ]
endfunction

function! airline#themes#get_highlight(group, ...)
  let fg = s:get_syn(a:group, 'fg')
  let bg = s:get_syn(a:group, 'bg')
  return s:get_array(fg, bg, a:000)
endfunction

function! airline#themes#get_highlight2(fg, bg, ...)
  let fg = s:get_syn(a:fg[0], a:fg[1])
  let bg = s:get_syn(a:bg[0], a:bg[1])
  return s:get_array(fg, bg, a:000)
endfunction

function! airline#themes#exec_highlight_separator(from, to)
  let l:from = airline#themes#get_highlight(a:from)
  let l:to = airline#themes#get_highlight(a:to)
  let group = a:from.'_to_'.a:to
  call airline#exec_highlight(group, [ l:to[1], l:from[1], l:to[3], l:from[3] ])
  return group
endfunction
