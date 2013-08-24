" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

" generates a dictionary which defines the colors for each highlight group
function! airline#themes#generate_color_map(section1, section2, section3, file)
  "                       guifg           guibg           ctermfg         ctermbg         gui/term
  return {
      \ 'airline_a':    [ a:section1[0] , a:section1[1] , a:section1[2] , a:section1[3] , get(a:section1 , 4 , 'bold') ] ,
      \ 'airline_b':    [ a:section2[0] , a:section2[1] , a:section2[2] , a:section2[3] , get(a:section2 , 4 , ''    ) ] ,
      \ 'airline_c':    [ a:section3[0] , a:section3[1] , a:section3[2] , a:section3[3] , get(a:section3 , 4 , ''    ) ] ,
      \ 'airline_file': [ a:file[0]     , a:file[1]     , a:file[2]     , a:file[3]     , get(a:file     , 4 , ''    ) ] ,
      \ 'airline_x':    [ a:section3[0] , a:section3[1] , a:section3[2] , a:section3[3] , get(a:section3 , 4 , ''    ) ] ,
      \ 'airline_y':    [ a:section2[0] , a:section2[1] , a:section2[2] , a:section2[3] , get(a:section2 , 4 , ''    ) ] ,
      \ 'airline_z':    [ a:section1[0] , a:section1[1] , a:section1[2] , a:section1[3] , get(a:section1 , 4 , ''    ) ] ,
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

function! airline#themes#patch(palette)
  " this is a pretty heavy handed, but it works...
  " basically, look for the 'airline_file' group and copy the bg
  " colors from 'airline_c' into it.
  for mode in keys(a:palette)
    let overrides = split(mode, '_')
    let mode_colors = a:palette[overrides[0]]
    if exists('mode_colors.airline_file')
      let file_colors = mode_colors.airline_file
      let file_colors[1] = mode_colors.airline_c[1]
      let file_colors[3] = mode_colors.airline_c[3]

      if len(overrides) > 1
        let override_colors = a:palette[overrides[0].'_'.overrides[1]]
        let override_colors.airline_file = copy(file_colors)
        let override_status_colors = get(override_colors, 'airline_c', mode_colors.airline_c)
        let override_colors.airline_file[1] = override_status_colors[1]
        let override_colors.airline_file[3] = override_status_colors[3]
      endif
    endif
  endfor
endfunction

