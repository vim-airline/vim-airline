let s:file = [ '#66d9ef' , '#465457' , 81 , 67 , 'bold' ]

" Normal mode
let s:N1 = [ '#080808' , '#e6db74' , 232 , 144 ] " mode
let s:N2 = [ '#f8f8f0' , '#232526' , 253 , 16  ] " info
let s:N3 = [ '#f8f8f0' , '#465457' , 253 , 67  ] " statusline

let g:airline#themes#molokai#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)
let g:airline#themes#molokai#normal_modified = {
      \ 'info_separator': [ '#232526' , '#e6db74' , 16  , 144 , '' ] ,
      \ 'statusline':     [ '#080808' , '#e6db74' , 232 , 144 , '' ] ,
      \ }


" Insert mode
let s:I1 = [ '#080808' , '#66d9ef' , 232 , 81 ]
let s:I2 = [ '#f8f8f0' , '#232526' , 253 , 16 ]
let s:I3 = [ '#f8f8f0' , '#465457' , 253 , 67 ]

let g:airline#themes#molokai#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
let g:airline#themes#molokai#insert_modified = {
      \ 'info_separator': [ '#232526' , '#66d9ef' , 16  , 81 , '' ] ,
      \ 'statusline':     [ '#080808' , '#66d9ef' , 232 , 81 , '' ] ,
      \ }


" Replace mode
let g:airline#themes#molokai#replace = copy(g:airline#themes#molokai#insert)
let g:airline#themes#molokai#replace.mode           = [ s:I1[0]   , '#ef5939' , s:I1[2] , 166     , ''     ]
let g:airline#themes#molokai#replace.mode_separator = [ '#ef5939' , s:I2[1]   , 166     , s:I2[3] , ''     ]
let g:airline#themes#molokai#replace_modified       = {
      \ 'info_separator': [ '#232526' , '#ef5939' , 16  , 166 , '' ] ,
      \ 'statusline':     [ '#080808' , '#ef5939' , 232 , 166 , '' ] ,
      \ }


" Visual mode
let s:V1 = [ '#080808' , '#fd971f' , 232 , 208 ]
let s:V2 = [ '#f8f8f0' , '#232526' , 253 , 16  ]
let s:V3 = [ '#f8f8f0' , '#465457' , 253 , 67  ]

let g:airline#themes#molokai#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
let g:airline#themes#molokai#visual_modified = {
      \ 'info_separator': [ '#232526' , '#fd971f' , 16  , 208 , '' ] ,
      \ 'statusline':     [ '#080808' , '#fd971f' , 232 , 208 , '' ] ,
      \ }


" Inactive
let s:IA = [ '#1b1d1e' , '#465457' , 233 , 67 , '' ]
let g:airline#themes#molokai#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)


" CtrlP
if get(g:, 'loaded_ctrlp', 0)
  let g:airline#themes#molokai#ctrlp = airline#extensions#ctrlp#generate_color_map(
        \ [ '#f8f8f0' , '#465457' , 253 , 67  , ''     ] ,
        \ [ '#f8f8f0' , '#232526' , 253 , 16  , ''     ] ,
        \ [ '#080808' , '#e6db74' , 232 , 144 , 'bold' ] )
endif

