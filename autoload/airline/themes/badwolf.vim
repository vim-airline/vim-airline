let g:airline#themes#badwolf#inactive = { 'mode': [ '#45413b' , '#242321' , 238 , 235 , '' ] }

let s:N1 = [ '#141413' , '#aeee00' , 232 , 154 ]
let s:N2 = [ '#f4cf86' , '#45413b' , 222 , 238 ]
let s:N3 = [ '#8cffba' , '#242321' , 121 , 235 ]
let g:airline#themes#badwolf#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#badwolf#normal.file = [ '#ff2c4b' , '#242321' , 196 , 235 , '' ]

let g:airline#themes#badwolf#normal_modified = {
      \ 'mode_separator' : [ '#aeee00' , '#666462' , 154     , 241     , 'bold' ] ,
      \ 'info'           : [ '#f4cf86' , '#666462' , 222     , 241     , ''     ] ,
      \ 'info_separator' : [ '#666462' , '#45413b' , 241     , 238     , 'bold' ] ,
      \ 'statusline'     : [ '#ffa724' , '#45413b' , 214     , 238     , ''     ] ,
      \ }

let s:I1 = [ '#141413' , '#0a9dff' , 232 , 39  ]
let s:I2 = [ '#f4cf86' , '#005fff' , 222 , 27  ]
let s:I3 = [ '#0a9dff' , '#242321' , 39  , 235 ]
let g:airline#themes#badwolf#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#badwolf#insert_modified = {
      \ 'info_separator' : [ '#005fff' , '#45413b' , 27      , 238     , 'bold' ] ,
      \ 'statusline'     : [ '#ffa724' , '#45413b' , 214     , 238     , ''     ] ,
      \ }
let g:airline#themes#badwolf#insert_paste = {
      \ 'mode':           [ s:I1[0]   , '#d78700' , s:I1[2] , 172     , ''     ] ,
      \ 'mode_separator': [ '#d78700' , s:I2[1]   , 172     , s:I2[3] , ''     ] ,
      \ }
let g:airline#themes#badwolf#insert_replace = {
      \ 'mode':           [ s:I2[0]   , '#ff0000' , s:I2[2] , 196     , ''     ] ,
      \ 'mode_separator': [ '#ff0000' , s:I2[1]   , 196     , s:I2[3] , ''     ] ,
      \ }

let s:V1 = [ '#141413' , '#ffa724' , 232 , 214 ]
let s:V2 = [ '#000000' , '#fade3e' , 16  , 221 ]
let s:V3 = [ '#000000' , '#b88853' , 16  , 137 ]
let g:airline#themes#badwolf#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#badwolf#visual_modified = {
      \ 'info_separator' : [ '#fade3e' , '#c7915b' , 221     , 173     , 'bold' ] ,
      \ 'statusline'     : [ '#000000' , '#c7915b' , 16      , 173     , ''     ] ,
      \ }
