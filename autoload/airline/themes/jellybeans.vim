let g:airline#themes#jellybeans#palette = {}

function! airline#themes#jellybeans#invert( highlight )
    let l:inverted_highlight = copy(a:highlight)
    let l:inverted_highlight[0] = a:highlight[1]
    let l:inverted_highlight[1] = a:highlight[0]
    let l:inverted_highlight[2] = a:highlight[3]
    let l:inverted_highlight[3] = a:highlight[2]
    return l:inverted_highlight
endfunction

" The name of the function must be 'refresh'.
function! airline#themes#jellybeans#refresh()
  " This theme is an example of how to use helper functions to extract highlight
  " values from the corresponding colorscheme. It was written in a hurry, so it
  " is very minimalistic. If you are a jellybeans user and want to make updates,
  " please send pull requests.

  " Here are examples where the entire highlight group is copied and an airline
  " compatible color array is generated.
  let s:T1 = airline#themes#get_highlight('DbgCurrent', 'bold')
  let s:T2 = airline#themes#get_highlight('Folded')
  let s:T3 = airline#themes#get_highlight('NonText')

  let g:airline#themes#jellybeans#palette.accents = {
        \ 'red': airline#themes#get_highlight('Constant'),
        \ }

  let l:invert = 0

  let s:N1 = airline#themes#get_highlight2(['Delimiter', 'fg'], ['SignColumn', 'bg'], '')
  if l:invert
    let s:N1 = airline#themes#jellybeans#invert( s:N1 )
  endif
  let s:N2 = airline#themes#get_highlight('Folded')
  let s:N3 = airline#themes#get_highlight2(['Delimiter', 'fg'], ['LineNr', 'bg'], '')
  let g:airline#themes#jellybeans#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#jellybeans#palette.normal_modified = {
        \ 'airline_c': [ '#ffb964', '', 215, '', '' ]
        \ }

  let s:I1 = airline#themes#get_highlight2(['String', 'fg'], ['SignColumn', 'bg'], '')
  if l:invert
    let s:I1 = airline#themes#jellybeans#invert( s:I1 )
  endif
  let s:I2 = airline#themes#get_highlight('Folded')
  let s:I3 = airline#themes#get_highlight2(['String', 'fg'], ['LineNr', 'bg'], '')
  let g:airline#themes#jellybeans#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
  let g:airline#themes#jellybeans#palette.insert_modified = g:airline#themes#jellybeans#palette.normal_modified

  let s:R1 = airline#themes#get_highlight2(['WildMenu', 'fg'], ['SignColumn', 'bg'], '')
  if l:invert
    let s:R1 = airline#themes#jellybeans#invert( s:R1 )
  endif
  let s:R2 = airline#themes#get_highlight('Folded')
  let s:R3 = airline#themes#get_highlight2(['WildMenu', 'fg'], ['LineNr', 'bg'], '')
  let g:airline#themes#jellybeans#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
  let g:airline#themes#jellybeans#palette.replace_modified = g:airline#themes#jellybeans#palette.normal_modified

  " Sometimes you want to mix and match colors from different groups, you can do
  " that with this method.
  let s:V1 = airline#themes#get_highlight2(['Identifier', 'fg'], ['SignColumn', 'bg'], '')
  if l:invert
    let s:V1 = airline#themes#jellybeans#invert( s:V1 )
  endif
  let s:V2 = airline#themes#get_highlight('Folded')
  let s:V3 = airline#themes#get_highlight2(['Identifier', 'fg'], ['LineNr', 'bg'], '')
  let g:airline#themes#jellybeans#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
  let g:airline#themes#jellybeans#palette.visual_modified = g:airline#themes#jellybeans#palette.normal_modified

  " And of course, you can always do it manually as well.
  let s:IA = [ '#444444', '#1c1c1c', 237, 234 ]
  let g:airline#themes#jellybeans#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
  let g:airline#themes#jellybeans#palette.inactive_modified = g:airline#themes#jellybeans#palette.normal_modified
endfunction

call airline#themes#jellybeans#refresh()

