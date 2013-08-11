" vim-airline companion theme of Luna
" (https://github.com/Pychimp/vim-luna)

let s:file = [ '#ffffff' , '#002b2b' , 231 , 23 , '' ]
let s:N1 = [ '#ffffff' , '#005252' , 231  , 36 ] 
let s:N2 = [ '#ffffff' , '#003f3f' , 231 , 29 ] 
let s:N3 = [ '#ffffff' , '#002b2b' , 231  , 23 ] 

let g:airline#themes#luna#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)

let g:airline#themes#luna#normal_modified = {
      \ 'info_separator': [ '#003f3f' , '#450000' , 29     , 52      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#450000' , 231     , 52      , ''     ] ,
      \ }


let s:I1 = [ '#ffffff' , '#789f00' , 231  , 106  ] 
let s:I2 = [ '#ffffff' , '#003f3f' , 231 , 29  ] 
let s:I3 = [ '#ffffff' , '#002b2b' , 231  , 23  ] 
let g:airline#themes#luna#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
let g:airline#themes#luna#insert_modified = {
      \ 'info_separator': [ '#003f3f' , '#005e5e' , 29      , 52      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#005e5e' , 255     , 52      , ''     ] ,
      \ }
let g:airline#themes#luna#insert_paste = {
      \ 'mode':           [ s:I1[0]   , '#789f00' , s:I1[2] , 106     , ''     ] ,
      \ 'mode_separator': [ '#789f00' , s:I2[1]   , 106     , s:I2[3] , ''     ] ,
      \ }


let g:airline#themes#luna#replace = copy(g:airline#themes#luna#insert)
let g:airline#themes#luna#replace.mode           = [ s:I2[0]   , '#920000' , s:I2[2] , 88     , ''     ]
let g:airline#themes#luna#replace.mode_separator = [ '#920000' , s:I2[1]   , 88     , s:I2[3] , ''     ]
let g:airline#themes#luna#replace_modified = g:airline#themes#luna#insert_modified

let s:V1 = [ '#ffff9a' , '#ff8036' , 222 , 208 ]
let s:V2 = [ '#ffffff' , '#003f3f' , 231 , 29 ]
let s:V3 = [ '#ffffff' , '#002b2b' , 231  , 23  ]
let g:airline#themes#luna#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
let g:airline#themes#luna#visual_modified = {
      \ 'info_separator': [ '#003f3f' , '#450000' , 29     , 52      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#450000' , 231     , 52      , ''     ] ,
      \ }

let s:IA = [ '#4e4e4e' , '#002b2b' , 59 , 23 , '' ]
let g:airline#themes#luna#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)


if get(g:, 'loaded_ctrlp', 0)
  let g:airline#themes#luna#ctrlp = airline#extensions#ctrlp#generate_color_map(
    \ [ '#ffffff' , '#002b2b' , 231 , 23 , ''     ] ,
    \ [ '#ffffff' , '#005252' , 231 , 36 , ''     ] ,
    \ [ '#ffffff' , '#973d45' , 231 , 95 , ''     ] )
endif
