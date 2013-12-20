let g:airline#themes#jellybeans#palette = {}

" Here are examples where the entire highlight group is copied and an airline
" compatible color array is generated.
function! s:get_highlight(group)
  return airline#themes#get_highlight(a:group)
endfunction

" Sometimes you want to mix and match colors from different groups, you can do
" that with this method.
function! s:get_highlight_inverse(group)
  return airline#themes#get_highlight2([a:group, 'bg'], [a:group, 'fg'])
endfunction

" The name of the function must be 'refresh'.
function! airline#themes#jellybeans#refresh()
  " This theme is an example of how to use helper functions to extract highlight
  " values from the corresponding colorscheme. It was written in a hurry, so it
  " is very minimalistic. If you are a jellybeans user and want to make updates,
  " please send pull requests.

  " And of course, you can always do it manually as well.
  let s:warn = s:get_highlight('ErrorMsg')

  let s:N1 = s:get_highlight_inverse('Statement')
  let s:N2 = s:get_highlight('StatusLine')
  let s:N3 = s:get_highlight('NonText')

  let g:airline#themes#jellybeans#palette.accents = {
        \ 'red': s:get_highlight('Constant'),
        \ }

  let g:airline#themes#jellybeans#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#jellybeans#palette.normal.airline_warning = s:warn
  let g:airline#themes#jellybeans#palette.normal_modified = {
        \ 'airline_c': s:get_highlight('Type'),
        \ 'airline_warning': s:warn }

  let s:I = s:get_highlight_inverse('Type')
  let g:airline#themes#jellybeans#palette.insert = airline#themes#generate_color_map(s:I, s:N2, s:N3)
  let g:airline#themes#jellybeans#palette.insert.airline_warning = g:airline#themes#jellybeans#palette.normal.airline_warning
  let g:airline#themes#jellybeans#palette.insert_modified = g:airline#themes#jellybeans#palette.normal_modified

  let s:R = s:get_highlight_inverse('Constant')
  let g:airline#themes#jellybeans#palette.replace = airline#themes#generate_color_map(s:R, s:N2, s:N3)
  let g:airline#themes#jellybeans#palette.replace.airline_warning = g:airline#themes#jellybeans#palette.normal.airline_warning
  let g:airline#themes#jellybeans#palette.replace_modified = g:airline#themes#jellybeans#palette.normal_modified

  let s:V = s:get_highlight_inverse('Identifier')
  let g:airline#themes#jellybeans#palette.visual = airline#themes#generate_color_map(s:V, s:N2, s:N3)
  let g:airline#themes#jellybeans#palette.visual.airline_warning = g:airline#themes#jellybeans#palette.normal.airline_warning
  let g:airline#themes#jellybeans#palette.visual_modified = g:airline#themes#jellybeans#palette.normal_modified

  let s:N2 = s:get_highlight('StatusLineNC')
  let g:airline#themes#jellybeans#palette.inactive = airline#themes#generate_color_map(s:N2, s:N2, s:N3)
  let g:airline#themes#jellybeans#palette.inactive_modified = g:airline#themes#jellybeans#palette.normal_modified
endfunction

call airline#themes#jellybeans#refresh()

