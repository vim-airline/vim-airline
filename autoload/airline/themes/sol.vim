" vim-airline companion theme of Sol
" (https://github.com/Pychimp/vim-sol)

let g:airline#themes#sol#palette = {}

let g:airline#themes#sol#palette.accents = {
      \ 'red': [ '#ffffff' , '' , 231 , '' , '' ],
      \ }


" let s:N1 = [ '#5b5b5b' , '#b7b7b7' , 231  , 36 ]
" let s:N2 = [ '#5b5b5b' , '#c3c3c3' , 231 , 29 ]
" let s:N3 = [ '#5b5b5b' , '#d0d0d0' , 231  , 23 ]
" let s:N1 = [ '#343434' , '#969696' , 231  , 36 ]
" let s:N2 = [ '#343434' , '#aaaaaa' , 231 , 29 ]
" let s:N3 = [ '#343434' , '#bdbdbd' , 231  , 23 ]
let s:N1 = [ '#343434' , '#a0a0a0' , 231  , 36 ]
let s:N2 = [ '#343434' , '#b3b3b3' , 231 , 29 ]
let s:N3 = [ '#343434' , '#c7c7c7' , 231  , 23 ]
let g:airline#themes#sol#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#sol#palette.normal_modified = {
      \ 'airline_c': [ '#ffffff' , '#ff3535' , 231     , 52      , ''     ] ,
      \ }


let s:I1 = [ '#eeeeee' , '#09643f' , 231 , 106 ]
let s:I2 = [ '#343434' , '#a3a3a3' , 231 , 29  ]
let s:I3 = [ '#343434' , '#b0b0b0' , 231 , 23  ]
let g:airline#themes#sol#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#sol#palette.insert_modified = {
      \ 'airline_c': [ '#ffffff' , '#ff6868' , 255     , 52      , ''     ] ,
      \ }
let g:airline#themes#sol#palette.insert_paste = {
      \ 'airline_a': [ s:I1[0]   , '#09643f' , s:I1[2] , 106     , ''     ] ,
      \ }


let g:airline#themes#sol#palette.replace = copy(g:airline#themes#sol#palette.insert)
let g:airline#themes#sol#palette.replace.airline_a = [ s:I1[0]   , '#ff2121' , s:I2[2] , 88     , ''     ]
let g:airline#themes#sol#palette.replace.airline_z = [ s:I1[0]   , '#ff2121' , s:I2[2] , 88     , ''     ]
let g:airline#themes#sol#palette.replace_modified = g:airline#themes#sol#palette.insert_modified

let s:V1 = [ '#ffff9a' , '#ff6003' , 222 , 208 ]
let s:V2 = [ '#343434' , '#a3a3a3' , 231 , 29 ]
let s:V3 = [ '#343434' , '#b0b0b0' , 231  , 23  ]
let g:airline#themes#sol#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#sol#palette.visual_modified = {
      \ 'airline_c': [ '#ffffff' , '#ff3535' , 231     , 52      , ''     ] ,
      \ }

let s:IA = [ '#777777' , '#c7c7c7' , 59 , 23 , '' ]
let g:airline#themes#sol#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#sol#palette.inactive_modified = {
      \ 'airline_c': [ '#ff3535' , ''        , 52      , ''      , ''     ] ,
       \ }


if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#sol#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ '#343434' , '#c7c7c7' , 231 , 23 , ''     ] ,
      \ [ '#343434' , '#b3b3b3' , 231 , 36 , ''     ] ,
      \ [ '#eeeeee' , '#007fff' , 231 , 95 , ''     ] )

let g:airline#themes#sol#palette.tabline = {
      \ 'airline_tab':  ['#343434', '#b3b3b3',  231, 29, ''],
      \ 'airline_tabsel':  ['#ffffff', '#004b9a',  231, 36, ''],
      \ 'airline_tabtype':  ['#343434', '#a0a0a0',  231, 36, ''],
      \ 'airline_tabfill':  ['#343434', '#c7c7c7',  231, 23, ''],
      \ 'airline_tabmod':  ['#ffffff', '#ff6868',  231, 88, ''],
      \ }

let s:WI = [ '#eeeeee', '#ff0f38', 231, 88 ]
let g:airline#themes#sol#palette.normal.airline_warning = [
     \ s:WI[0], s:WI[1], s:WI[2], s:WI[3]
     \ ]

let g:airline#themes#sol#palette.normal_modified.airline_warning =
    \ g:airline#themes#sol#palette.normal.airline_warning


let g:airline#themes#sol#palette.insert.airline_warning =
    \ g:airline#themes#sol#palette.normal.airline_warning

let g:airline#themes#sol#palette.insert_modified.airline_warning =
    \ g:airline#themes#sol#palette.normal.airline_warning

let g:airline#themes#sol#palette.visual.airline_warning =
    \ g:airline#themes#sol#palette.normal.airline_warning

let g:airline#themes#sol#palette.visual_modified.airline_warning =
    \ g:airline#themes#sol#palette.normal.airline_warning

let g:airline#themes#sol#palette.replace.airline_warning =
    \ g:airline#themes#sol#palette.normal.airline_warning

let g:airline#themes#sol#palette.replace_modified.airline_warning =
    \ g:airline#themes#sol#palette.normal.airline_warning
