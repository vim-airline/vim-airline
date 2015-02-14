let g:airline#themes#jellybeans#palette = {}

" The name of the function must be 'refresh'.
function! airline#themes#jellybeans#refresh()
  " This theme is an example of how to use helper functions to extract highlight
  " values from the corresponding colorscheme. It was written in a hurry, so it
  " is very minimalistic. If you are a jellybeans user and want to make updates,
  " please send pull requests.

  let s:warn = airline#themes#get_highlight('ErrorMsg')

  let s:N1 = airline#themes#get_highlight_reverse('Statement')
  let s:N2 = airline#themes#get_highlight('StatusLine')
  let s:N3 = airline#themes#get_highlight('NonText')

  let g:airline#themes#jellybeans#palette.accents = {
        \ 'red': airline#themes#get_highlight('Constant'),
        \ }

  let g:airline#themes#jellybeans#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#jellybeans#palette.normal.airline_warning = s:warn
  let g:airline#themes#jellybeans#palette.normal_modified = {
        \ 'airline_c': airline#themes#get_highlight2(['Type', 'fg'], ['NonText', 'bg']),
        \ 'airline_warning': s:warn }

  let s:I = airline#themes#get_highlight_reverse('Type')
  let g:airline#themes#jellybeans#palette.insert = airline#themes#generate_color_map(s:I, s:N2, s:N3)
  let g:airline#themes#jellybeans#palette.insert.airline_warning = g:airline#themes#jellybeans#palette.normal.airline_warning
  let g:airline#themes#jellybeans#palette.insert_modified = g:airline#themes#jellybeans#palette.normal_modified

  let s:R = airline#themes#get_highlight_reverse('Constant')
  let g:airline#themes#jellybeans#palette.replace = airline#themes#generate_color_map(s:R, s:N2, s:N3)
  let g:airline#themes#jellybeans#palette.replace.airline_warning = g:airline#themes#jellybeans#palette.normal.airline_warning
  let g:airline#themes#jellybeans#palette.replace_modified = g:airline#themes#jellybeans#palette.normal_modified

  let s:V = airline#themes#get_highlight_reverse('Identifier')
  let g:airline#themes#jellybeans#palette.visual = airline#themes#generate_color_map(s:V, s:N2, s:N3)
  let g:airline#themes#jellybeans#palette.visual.airline_warning = g:airline#themes#jellybeans#palette.normal.airline_warning
  let g:airline#themes#jellybeans#palette.visual_modified = g:airline#themes#jellybeans#palette.normal_modified

  let s:N2 = airline#themes#get_highlight('StatusLineNC')
  let g:airline#themes#jellybeans#palette.inactive = airline#themes#generate_color_map(s:N2, s:N2, s:N3)
  let g:airline#themes#jellybeans#palette.inactive_modified = g:airline#themes#jellybeans#palette.normal_modified
endfunction

call airline#themes#jellybeans#refresh()

