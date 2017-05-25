" vim:foldmethod=marker:foldlevel=0:textwidth=79
"
" Minimal Theme
" Inspiration from Monochrome
" Author: Pratheek <https://github.com/Pychimp>

" NOTE: There is a *known bug*, that I'm not able to squash !
"       This Airline theme reads the `&background` that is loaded from a theme
"       set by the user, and based on it being dark or light theme, this one
"       sets the appropriate values.
"
"       This works fine in GVim !
"       (Tested with dark themes such as: koehler, darkblue slate, and my own
"       luna; and with light themes such as: autumnleaf, pyte, eclipse, and my
"       own sol, and it works fine !)
"
"       But in terminal vim, it _always_ defaults to light varient,
"       (Even if the user uses a dark theme, and sets
"       `set background=dark` their vimrc)
"
"       So, If anyone can point out, what I'm doing wrong, I'll be thankful to
"       them ! :)
"
"

" Settings for light theme(s) ----- {{{
if (&background == "light")
    let g:airline#themes#minimal#palette = {}

    " TODO: Using GUI values, the cterm values must be set
    let g:airline#themes#minimal#palette.accents = {
          \ 'red': [ '#ff2121' , '' , 196 , '' , '' ],
          \ }

    let s:N1 = [ '#414141' , '#e1e1e1' , 59 , 188 ]
    let s:N2 = [ '#414141' , '#e1e1e1' , 59 , 188 ]
    let s:N3 = [ '#414141' , '#e1e1e1' , 59 , 188 ]
    let g:airline#themes#minimal#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
    let g:airline#themes#minimal#palette.normal_modified = {
          \ 'airline_c': [ '#e25000' , '#e1e1e1' , 166 , 188 , '' ] ,
          \ }

    let s:I1 = [ '#0d935c' , '#e1e1e1' , 29 , 188 ]
    let s:I2 = [ '#0d935c' , '#e1e1e1' , 29 , 188 ]
    let s:I3 = [ '#0d935c' , '#e1e1e1' , 29 , 188 ]
    let g:airline#themes#minimal#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
    let g:airline#themes#minimal#palette.insert_modified = {
          \ 'airline_c': [ '#e25000' , '#e1e1e1' , 166 , 188 , '' ] ,
          \ }
    let g:airline#themes#minimal#palette.insert_paste = {
          \ 'airline_a': [ s:I1[0]   , '#e1e1e1' , s:I1[2] , 188 , '' ] ,
          \ }

    let g:airline#themes#minimal#palette.replace = copy(g:airline#themes#minimal#palette.insert)
    let g:airline#themes#minimal#palette.replace.airline_a = [ '#b30000' , s:I1[1] , 124 , s:I1[3] , '' ]
    let g:airline#themes#minimal#palette.replace.airline_z = [ '#b30000' , s:I1[1] , 124 , s:I1[3] , '' ]
    let g:airline#themes#minimal#palette.replace_modified = g:airline#themes#minimal#palette.insert_modified

    let s:V1 = [ '#0000b3' , '#e1e1e1' , 19 , 188 ]
    let s:V2 = [ '#0000b3' , '#e1e1e1' , 19 , 188 ]
    let s:V3 = [ '#0000b3' , '#e1e1e1' , 19 , 188 ]
    let g:airline#themes#minimal#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
    let g:airline#themes#minimal#palette.visual_modified = {
          \ 'airline_c': [ '#e25000' , '#e1e1e1' , 166 , 188 , '' ] ,
          \ }

    let s:IA = [ '#a1a1a1' , '#dddddd' , 145 , 188 , '' ]
    let g:airline#themes#minimal#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
    let g:airline#themes#minimal#palette.inactive_modified = {
          \ 'airline_c': [ '#e25000' , '' , 166 , '' , '' ] ,
           \ }

    " TODO: Tabs colors need to be converted from Sol to minimal ones
    " TODO: add cterm from here
    let g:airline#themes#minimal#palette.tabline = {
          \ 'airline_tab':      ['#414141' , '#e1e1e1' , 59  , 188 , '' ],
          \ 'airline_tabsel':   ['#e1e1e1' , '#007599' , 188 , 30  , '' ],
          \ 'airline_tabtype':  ['#414141' , '#e1e1e1' , 59  , 188 , '' ],
          \ 'airline_tabfill':  ['#414141' , '#e1e1e1' , 59  , 188 , '' ],
          \ 'airline_tabmod':   ['#e1e1e1' , '#007599' , 188 , 30  , '' ],
          \ }

    let s:WI = [ '#ff0000', '#e1e1e1', 196, 188 ]
    let g:airline#themes#minimal#palette.normal.airline_warning = [
         \ s:WI[0], s:WI[1], s:WI[2], s:WI[3]
         \ ]

    let g:airline#themes#minimal#palette.normal_modified.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.insert.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.insert_modified.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.visual.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.visual_modified.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.replace.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.replace_modified.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    if !get(g:, 'loaded_ctrlp', 0)
      finish
    endif
    let g:airline#themes#minimal#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
          \ [ '#414141' , '#e1e1e1' , 59  , 188 , ''     ] ,
          \ [ '#414141' , '#e1e1e1' , 59  , 188 , ''     ] ,
          \ [ '#e1e1e1' , '#007599' , 188 , 30  , ''     ] )

" --------
" }}}
" Settings for dark theme(s) ----- {{{
elseif(&background == "dark")
    let g:airline#themes#minimal#palette = {}

    " TODO: Using GUI values, the cterm values must be set
    let g:airline#themes#minimal#palette.accents = {
          \ 'red': [ '#ff2121' , '' , 196 , '' , '' ],
          \ }

    let s:N1 = [ '#c8c8c8' , '#2e2e2e' , 188 , 235 ]
    let s:N2 = [ '#c8c8c8' , '#2e2e2e' , 188 , 235 ]
    let s:N3 = [ '#c8c8c8' , '#2e2e2e' , 188 , 235 ]
    let g:airline#themes#minimal#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
    let g:airline#themes#minimal#palette.normal_modified = {
          \ 'airline_c': [ '#e25000' , '#2e2e2e' , 166 , 235 , '' ] ,
          \ }

    let s:I1 = [ '#11c279' , '#2e2e2e' , 36 , 235 ]
    let s:I2 = [ '#11c279' , '#2e2e2e' , 36 , 235 ]
    let s:I3 = [ '#11c279' , '#2e2e2e' , 36 , 235 ]
    let g:airline#themes#minimal#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
    let g:airline#themes#minimal#palette.insert_modified = {
          \ 'airline_c': [ '#e25000' , '#2e2e2e' , 166 , 235 , '' ] ,
          \ }
    let g:airline#themes#minimal#palette.insert_paste = {
          \ 'airline_a': [ s:I1[0]   , '#2e2e2e' , s:I1[2] , 235 , '' ] ,
          \ }

    let g:airline#themes#minimal#palette.replace = copy(g:airline#themes#minimal#palette.insert)
    let g:airline#themes#minimal#palette.replace.airline_a = [ '#e60000' , s:I1[1] , 160 , s:I1[3] , '' ]
    let g:airline#themes#minimal#palette.replace.airline_z = [ '#e60000' , s:I1[1] , 160 , s:I1[3] , '' ]
    let g:airline#themes#minimal#palette.replace_modified = g:airline#themes#minimal#palette.insert_modified

    let s:V1 = [ '#6565ff' , '#2e2e2e' , 63 , 235 ]
    let s:V2 = [ '#6565ff' , '#2e2e2e' , 63 , 235 ]
    let s:V3 = [ '#6565ff' , '#2e2e2e' , 63 , 235 ]
    let g:airline#themes#minimal#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
    let g:airline#themes#minimal#palette.visual_modified = {
          \ 'airline_c': [ '#e25000' , '#2e2e2e' , 166 , 235 , '' ] ,
          \ }

    let s:IA = [ '#5e5e5e' , '#222222' , 145 , 235 , '' ]
    let g:airline#themes#minimal#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
    let g:airline#themes#minimal#palette.inactive_modified = {
          \ 'airline_c': [ '#e25000' , '' , 166 , '' , '' ] ,
           \ }

    " TODO: Tabs colors need to be converted from Sol to minimal ones
    " TODO: add cterm from here
    let g:airline#themes#minimal#palette.tabline = {
          \ 'airline_tab':      ['#c8c8c8' , '#2e2e2e' , 59  , 235 , '' ],
          \ 'airline_tabsel':   ['#2e2e2e' , '#a4c639' , 235 , 30  , '' ],
          \ 'airline_tabtype':  ['#c8c8c8' , '#2e2e2e' , 59  , 235 , '' ],
          \ 'airline_tabfill':  ['#c8c8c8' , '#2e2e2e' , 59  , 235 , '' ],
          \ 'airline_tabmod':   ['#2e2e2e' , '#a4c639' , 235 , 30  , '' ],
          \ }

    let s:WI = [ '#ff0000', '#2e2e2e', 196, 188 ]
    let g:airline#themes#minimal#palette.normal.airline_warning = [
         \ s:WI[0], s:WI[1], s:WI[2], s:WI[3]
         \ ]

    let g:airline#themes#minimal#palette.normal_modified.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.insert.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.insert_modified.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.visual.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.visual_modified.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.replace.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    let g:airline#themes#minimal#palette.replace_modified.airline_warning =
        \ g:airline#themes#minimal#palette.normal.airline_warning

    if !get(g:, 'loaded_ctrlp', 0)
      finish
    endif
    let g:airline#themes#minimal#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
          \ [ '#c8c8c8' , '#2e2e2e' , 59  , 188 , ''     ] ,
          \ [ '#c8c8c8' , '#2e2e2e' , 59  , 188 , ''     ] ,
          \ [ '#2e2e2e' , '#a4c639' , 188 , 30  , ''     ] )
endif
" --------
" }}}

