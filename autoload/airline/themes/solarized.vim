let s:N1 = [ '#fdf6e3' , '#657b83' , 230 , 241 ]
let s:N2 = [ '#fdf6e3' , '#93a1a1' , 230 , 245 ]
let s:N3 = [ '#657b83' , '#fdf6e3' , 241 , 230 ]
let g:airline#themes#solarized#normal = {
      \ 'mode':           [ s:N1[0]   , s:N1[1]   , s:N1[2] , s:N1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:N1[1]   , s:N2[1]   , s:N1[3] , s:N2[3] , 'bold' ] ,
      \ 'info':           [ s:N2[0]   , s:N2[1]   , s:N2[2] , s:N2[3] , ''     ] ,
      \ 'info_separator': [ s:N2[1]   , s:N3[1]   , s:N2[3] , s:N3[3] , 'bold' ] ,
      \ 'statusline':     [ s:N3[0]   , s:N3[1]   , s:N3[2] , s:N3[3] , ''     ] ,
      \ 'file':           [ '#ff0000' , '#1c1c1c' , 160     , 233     , ''     ] ,
      \ 'inactive':       [ '#4e4e4e' , '#1c1c1c' , 239     , 234     , ''     ] ,
      \ }
let g:airline#themes#solarized#normal_modified = {
      \ 'info_separator': [ '#444444' , '#5f005f' , 238     , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }

let s:I1 = [ '#073642' , '#d33682' , 235 , 125 ]
let s:I2 = [ '#073642' , '#268bd2' , 235 , 33  ]
let s:I3 = [ '#073642' , '#2aa198' , 235 , 37  ]
let g:airline#themes#solarized#insert = {
      \ 'mode':           [ s:I1[0]   , s:I1[1]   , s:I1[2] , s:I1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:I1[1]   , s:I2[1]   , s:I1[3] , s:I2[3] , 'bold' ] ,
      \ 'info':           [ s:I2[0]   , s:I2[1]   , s:I2[2] , s:I2[3] , ''     ] ,
      \ 'info_separator': [ s:I2[1]   , s:I3[1]   , s:I2[3] , s:I3[3] , 'bold' ] ,
      \ 'statusline':     [ s:I3[0]   , s:I3[1]   , s:I3[2] , s:I3[3] , ''     ] ,
      \ }
let g:airline#themes#solarized#insert_modified = {
      \ 'info_separator': [ '#005fff' , '#5f005f' , 27      , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }

let s:V1 = [ '#002b36' , '#b58900' , 234 , 136 ]
let s:V2 = [ '#073642' , '#cb4b16' , 235 , 166 ]
let s:V3 = [ '#fdf6e3' , '#dc322f' , 230 , 160 ]
let g:airline#themes#solarized#visual = {
      \ 'mode':           [ s:V1[0]   , s:V1[1]   , s:V1[2] , s:V1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:V1[1]   , s:V2[1]   , s:V1[3] , s:V2[3] , 'bold' ] ,
      \ 'info':           [ s:V2[0]   , s:V2[1]   , s:V2[2] , s:V2[3] , ''     ] ,
      \ 'info_separator': [ s:V2[1]   , s:V3[1]   , s:V2[3] , s:V3[3] , 'bold' ] ,
      \ 'statusline':     [ s:V3[0]   , s:V3[1]   , s:V3[2] , s:V3[3] , ''     ] ,
      \ }
let g:airline#themes#solarized#visual_modified = {
      \ 'info_separator': [ '#ff5f00' , '#5f005f' , 202     , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }
