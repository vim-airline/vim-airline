let s:file = [ '#66d9ef' , '#465457' , 81 , 67 , 'bold' ]

" Normal mode
let s:N1 = [ '#080808' , '#e6db74' , 232 , 144 ]
let s:N2 = [ ''        , '#232526' , 232 , 16  ]
let s:N3 = [ ''        , '#465457' , 232 , 67  ]

let g:airline#themes#molokai#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)
let g:airline#themes#molokai#normal_modified = {
      \ 'info_separator': [ ''        , '#e6db74' , 232 , 144 , '' ] ,
      \ 'statusline':     [ '#080808' , '#e6db74' , 232 , 144 , '' ] ,
      \ }


" Insert mode
let s:I1 = [ '' , '#66d9ef' , 232 , 81  ]
let s:I2 = [ '' , '#232526' , 232 , 27  ]
let s:I3 = [ '' , '#465457' , 232 , 67  ]

let g:airline#themes#molokai#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
let g:airline#themes#molokai#insert_modified = {
      \ 'info_separator': [ ''        , '#66d9ef' , 232 , 81 , '' ] ,
      \ 'statusline':     [ '#080808' , '#66d9ef' , 232 , 81 , '' ] ,
      \ }


" Replace mode
let g:airline#themes#molokai#replace = copy(g:airline#themes#molokai#insert)
let g:airline#themes#molokai#replace.mode           = [ s:I2[0]   , '#ef5939' , s:I2[2] , 166     , ''     ]
let g:airline#themes#molokai#replace.mode_separator = [ '#ef5939' , s:I2[1]   , 166     , s:I2[3] , ''     ]
let g:airline#themes#molokai#replace_modified       = {
      \ 'info_separator': [ ''        , '#ef5939' , 232 , 166 , '' ] ,
      \ 'statusline':     [ '#080808' , '#ef5939' , 232 , 166 , '' ] ,
      \ }


" Visual mode
let s:V1 = [ '' , '#fd971f' , 232 , 208 ]
let s:V2 = [ '' , '#232526' , 232 , 16  ]
let s:V3 = [ '' , '#465457' , 232 , 67  ]

let g:airline#themes#molokai#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
let g:airline#themes#molokai#visual_modified = {
      \ 'info_separator': [ ''        , '#fd971f' , 232 , 208 , '' ] ,
      \ 'statusline':     [ '#080808' , '#fd971f' , 232 , 208 , '' ] ,
      \ }


" Inactive
let s:IA = [ '#1b1d1e' , '#465457' , 233 , 67 , '' ]
let g:airline#themes#molokai#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)

