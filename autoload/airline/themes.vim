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

function! airline#themes#get_highlight(group, ...)
  return call('airline#highlighter#get_highlight', [a:group] + a:000)
endfunction

function! airline#themes#get_highlight2(fg, bg, ...)
  return call('airline#highlighter#get_highlight2', [a:fg, a:bg] + a:000)
endfunction

function! airline#themes#patch(palette)
  for mode in keys(a:palette)
    if !has_key(a:palette[mode], 'airline_warning')
      let a:palette[mode]['airline_warning'] = [ '#000000', '#df5f00', 232, 166 ]
    endif
  endfor

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

