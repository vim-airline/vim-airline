let s:N1 = [ '#141413' , '#aeee00' , 232 , 154 ]
let s:N2 = [ '#f4cf86' , '#45413b' , 222 , 238 ]
let s:N3 = [ '#8cffba' , '#242321' , 121 , 235 ]
let g:airline#themes#badwolf#normal = {
      \ 'mode':           [ s:N1[0]    , s:N1[1]   , s:N1[2] , s:N1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:N1[1]    , s:N2[1]   , s:N1[3] , s:N2[3] , 'bold' ] ,
      \ 'info':           [ s:N2[0]    , s:N2[1]   , s:N2[2] , s:N2[3] , ''     ] ,
      \ 'info_separator': [ s:N2[1]    , s:N3[1]   , s:N2[3] , s:N3[3] , 'bold' ] ,
      \ 'statusline':     [ s:N3[0]    , s:N3[1]   , s:N3[2] , s:N3[3] , ''     ] ,
      \ 'file':           [ '#ff2c4b'  , '#242321' , 196     , 235     , ''     ] ,
      \ 'inactive':       [ '#45413b'  , '#242321' , 238     , 235     , ''     ] ,
      \ }
let g:airline#themes#badwolf#normal_modified = {
      \ 'mode_separator' : [ '#aeee00' , '#666462' , 154     , 241     , 'bold' ] ,
      \ 'info'           : [ '#f4cf86' , '#666462' , 222     , 241     , ''     ] ,
      \ 'info_separator' : [ '#666462' , '#45413b' , 241     , 238     , 'bold' ] ,
      \ 'statusline'     : [ '#ffa724' , '#45413b' , 214     , 238     , ''     ] ,
      \ 'inactive'       : [ '#88633f' , '#45413b' , 95      , 238     , ''     ] ,
      \ }

let s:I1 = [ '#141413' , '#0a9dff' , 232 , 39  ]
let s:I2 = [ '#f4cf86' , '#005fff' , 222 , 27  ]
let s:I3 = [ '#0a9dff' , '#242321' , 39  , 235 ]
let g:airline#themes#badwolf#insert = {
      \ 'mode':           [ s:I1[0]    , s:I1[1]   , s:I1[2] , s:I1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:I1[1]    , s:I2[1]   , s:I1[3] , s:I2[3] , 'bold' ] ,
      \ 'info':           [ s:I2[0]    , s:I2[1]   , s:I2[2] , s:I2[3] , ''     ] ,
      \ 'info_separator': [ s:I2[1]    , s:I3[1]   , s:I2[3] , s:I3[3] , 'bold' ] ,
      \ 'statusline':     [ s:I3[0]    , s:I3[1]   , s:I3[2] , s:I3[3] , ''     ] ,
      \ }
let g:airline#themes#badwolf#insert_modified = {
      \ 'info_separator' : [ '#005fff' , '#45413b' , 27      , 238     , 'bold' ] ,
      \ 'statusline'     : [ '#ffa724' , '#45413b' , 214     , 238     , ''     ] ,
      \ }

let s:V1 = [ '#141413' , '#ffa724' , 232 , 214 ]
let s:V2 = [ '#000000' , '#fade3e' , 16  , 221 ]
let s:V3 = [ '#000000' , '#b88853' , 16  , 137 ]
let g:airline#themes#badwolf#visual = {
      \ 'mode':           [ s:V1[0]    , s:V1[1]   , s:V1[2] , s:V1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:V1[1]    , s:V2[1]   , s:V1[3] , s:V2[3] , 'bold' ] ,
      \ 'info':           [ s:V2[0]    , s:V2[1]   , s:V2[2] , s:V2[3] , ''     ] ,
      \ 'info_separator': [ s:V2[1]    , s:V3[1]   , s:V2[3] , s:V3[3] , 'bold' ] ,
      \ 'statusline':     [ s:V3[0]    , s:V3[1]   , s:V3[2] , s:V3[3] , ''     ] ,
      \ }
let g:airline#themes#badwolf#visual_modified = {
      \ 'info_separator' : [ '#fade3e' , '#c7915b' , 221     , 173     , 'bold' ] ,
      \ 'statusline'     : [ '#000000' , '#c7915b' , 16      , 173     , ''     ] ,
      \ }
