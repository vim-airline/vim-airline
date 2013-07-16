let s:file = [ '#ff0000' , '#1c1c1c' , 160 , 233 , '' ]
let s:N1 = [ '#00005f' , '#dfff00' , 17  , 190 ]
let s:N2 = [ '#ffffff' , '#444444' , 255 , 238 ]
let s:N3 = [ '#9cffd3' , '#202020' , 85  , 234 ]
let g:airline#themes#dark#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)
let g:airline#themes#dark#normal_modified = {
      \ 'info_separator': [ '#444444' , '#5f005f' , 238     , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }


let s:I1 = [ '#00005f' , '#00dfff' , 17  , 45  ]
let s:I2 = [ '#ffffff' , '#005fff' , 255 , 27  ]
let s:I3 = [ '#ffffff' , '#000080' , 15  , 17  ]
let g:airline#themes#dark#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
let g:airline#themes#dark#insert_modified = {
      \ 'info_separator': [ '#005fff' , '#5f005f' , 27      , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }
let g:airline#themes#dark#insert_paste = {
      \ 'mode':           [ s:I1[0]   , '#d78700' , s:I1[2] , 172     , ''     ] ,
      \ 'mode_separator': [ '#d78700' , s:I2[1]   , 172     , s:I2[3] , ''     ] ,
      \ }


let g:airline#themes#dark#replace = copy(g:airline#themes#dark#insert)
let g:airline#themes#dark#replace.mode           = [ s:I2[0]   , '#af0000' , s:I2[2] , 124     , ''     ]
let g:airline#themes#dark#replace.mode_separator = [ '#af0000' , s:I2[1]   , 124     , s:I2[3] , ''     ]
let g:airline#themes#dark#replace_modified = g:airline#themes#dark#insert_modified


let s:V1 = [ '#000000' , '#ffaf00' , 232 , 214 ]
let s:V2 = [ '#000000' , '#ff5f00' , 232 , 202 ]
let s:V3 = [ '#ffffff' , '#5f0000' , 15  , 52  ]
let g:airline#themes#dark#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
let g:airline#themes#dark#visual_modified = {
      \ 'info_separator': [ '#ff5f00' , '#5f005f' , 202     , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }


let s:IA = [ '#4e4e4e' , '#1c1c1c' , 239 , 234 , '' ]
let g:airline#themes#dark#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)
let g:airline#themes#dark#inactive_modified = {
      \ 'statusline': [ '#5f005f' , '' , '53' , '' , '' ] ,
      \ }

