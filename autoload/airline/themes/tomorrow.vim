function! s:generate()
  let s:file = airline#themes#get_highlight('Constant')
  " clear out backgrounds so generate_color_map will fill them in
  let s:file[1] = ''
  let s:file[3] = ''

  let s:N1 = airline#themes#get_highlight2(['Normal', 'bg'], ['Directory', 'fg'], 'bold')
  let s:N2 = airline#themes#get_highlight('Pmenu')
  let s:N3 = airline#themes#get_highlight('CursorLine')
  let g:airline#themes#tomorrow#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)

  let group = airline#themes#get_highlight('vimCommand')
  let g:airline#themes#tomorrow#normal_modified = {
        \ 'statusline': [ group[0], '', group[2], '', '' ]
        \ }

  let s:I1 = airline#themes#get_highlight2(['Normal', 'bg'], ['MoreMsg', 'fg'], 'bold')
  let s:I2 = airline#themes#get_highlight2(['MoreMsg', 'fg'], ['Normal', 'bg'])
  let s:I3 = s:N3
  let g:airline#themes#tomorrow#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
  let g:airline#themes#tomorrow#insert_modified = g:airline#themes#tomorrow#normal_modified

  let s:R1 = airline#themes#get_highlight('Error', 'bold')
  let s:R2 = s:N2
  let s:R3 = s:N3
  let g:airline#themes#tomorrow#replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3, s:file)
  let g:airline#themes#tomorrow#replace_modified = g:airline#themes#tomorrow#normal_modified

  let s:V1 = airline#themes#get_highlight2(['Normal', 'bg'], ['Constant', 'fg'], 'bold')
  let s:V2 = airline#themes#get_highlight2(['Constant', 'fg'], ['Normal', 'bg'])
  let s:V3 = s:N3
  let g:airline#themes#tomorrow#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
  let g:airline#themes#tomorrow#visual_modified = g:airline#themes#tomorrow#normal_modified

  let s:IA = airline#themes#get_highlight2(['NonText', 'fg'], ['CursorLine', 'bg'])
  let g:airline#themes#tomorrow#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)
endfunction

call s:generate()
augroup airline_tomorrow
  autocmd!
  autocmd ColorScheme * call <sid>generate() | call airline#reload_highlight()
augroup END
