" Color palette
let s:gui_dark_gray = '#202020'
let s:cterm_dark_gray = 234
let s:gui_med_gray_hi = '#303030'
let s:cterm_med_gray_hi = 236
let s:gui_med_gray_lo = '#3a3a3a'
let s:cterm_med_gray_lo = 237
let s:gui_light_gray = '#505050'
let s:cterm_light_gray = 239
let s:gui_green = '#99cc99'
let s:cterm_green = 151
let s:gui_blue = '#6a9fb5'
let s:cterm_blue = 67
let s:gui_purple = '#aa759f'
let s:cterm_purple = 139
let s:gui_orange = '#d28445'
let s:cterm_orange = 173
let s:gui_red = '#ac4142'
let s:cterm_red = 131
let s:gui_pink = '#d7afd7'
let s:cterm_pink = 182

let s:file  = ['#ff0000', '', 160, '', '']

let g:airline#themes#base16#palette = {}

" Normal mode
let s:N1 = [s:gui_dark_gray, s:gui_green, s:cterm_dark_gray, s:cterm_green]
let s:N2 = [s:gui_light_gray, s:gui_med_gray_lo, s:cterm_light_gray, s:cterm_med_gray_lo]
let s:N3 = [s:gui_green, s:gui_med_gray_hi, s:cterm_green, s:cterm_med_gray_hi]
let g:airline#themes#base16#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)
let g:airline#themes#base16#palette.normal_modified = {
      \ 'airline_c': [s:gui_orange, s:gui_med_gray_hi, s:cterm_orange, s:cterm_med_gray_hi, ''],
      \ }

" Insert mode
let s:I1 = [s:gui_med_gray_hi, s:gui_blue, s:cterm_med_gray_hi, s:cterm_blue]
let s:I3 = [s:gui_blue, s:gui_med_gray_hi, s:cterm_blue, s:cterm_med_gray_hi]
let g:airline#themes#base16#palette.insert = airline#themes#generate_color_map(s:I1, s:N2, s:I3, s:file)
let g:airline#themes#base16#palette.insert_modified = copy(g:airline#themes#base16#palette.normal_modified)
let g:airline#themes#base16#palette.insert_paste = {
      \ 'airline_a': [s:gui_dark_gray, s:gui_orange, s:cterm_dark_gray, s:cterm_orange, ''],
      \ }

" Replace mode
let g:airline#themes#base16#palette.replace = {
      \ 'airline_a': [s:gui_dark_gray, s:gui_red, s:cterm_dark_gray, s:cterm_red, ''],
      \ 'airline_c': [s:gui_red, s:gui_med_gray_hi, s:cterm_red, s:cterm_med_gray_hi, ''],
      \ }
let g:airline#themes#base16#palette.replace_modified = copy(g:airline#themes#base16#palette.insert_modified)

" Visual mode
let s:V1 = [s:gui_dark_gray, s:gui_pink, s:cterm_dark_gray, s:cterm_pink]
let s:V3 = [s:gui_pink, s:gui_med_gray_hi, s:cterm_pink, s:cterm_med_gray_hi]
let g:airline#themes#base16#palette.visual = airline#themes#generate_color_map(s:V1, s:N2, s:V3, s:file)
let g:airline#themes#base16#palette.visual_modified = copy(g:airline#themes#base16#palette.insert_modified)

" Inactive window
let s:IA = [s:gui_dark_gray, s:gui_med_gray_hi, s:cterm_dark_gray, s:cterm_med_gray_hi, '']
let g:airline#themes#base16#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)

