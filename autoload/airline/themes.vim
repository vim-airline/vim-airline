" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

" generates a dictionary which defines the colors for each highlight group
function! airline#themes#generate_color_map(section1, section2, section3, file)
  "                         guifg           guibg           ctermfg         ctermbg         gui/term
  return {
      \ 'mode':           [ a:section1[0] , a:section1[1] , a:section1[2] , a:section1[3] , get(a:section1, 4, 'bold') ] ,
      \ 'mode_separator': [ a:section1[1] , a:section2[1] , a:section1[3] , a:section2[3] , ''                         ] ,
      \ 'info':           [ a:section2[0] , a:section2[1] , a:section2[2] , a:section2[3] , get(a:section2, 4, ''    ) ] ,
      \ 'info_separator': [ a:section2[1] , a:section3[1] , a:section2[3] , a:section3[3] , ''                         ] ,
      \ 'statusline':     [ a:section3[0] , a:section3[1] , a:section3[2] , a:section3[3] , get(a:section3, 4, ''    ) ] ,
      \ 'file':           [ a:file[0]     , a:file[1]     , a:file[2]     , a:file[3]     , get(a:file    , 4, ''    ) ] ,
      \ }
endfunction

function! s:get_syn(group, what)
  return synIDattr(synIDtrans(hlID(a:group)), a:what)
endfunction

function! s:get_array(fg, bg, opts)
  let fg = a:fg
  let bg = a:bg
  if fg == '' || fg < 0
    let fg = s:get_syn('Normal', 'fg')
  endif
  if bg == '' || bg < 0
    let bg = s:get_syn('Normal', 'bg')
  endif
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
