let s:N1 = [ '#141413' , '#aeee00' , 232 , 154 ] " blackestgravel & lime
let s:N2 = [ '#f4cf86' , '#45413b' , 222 , 238 ] " dirtyblonde    & deepgravel
let s:N3 = [ '#8cffba' , '#242321' , 121 , 235 ] " saltwatertaffy & darkgravel
let s:N4 = [ '#666462' , 241 ]                   " mediumgravel

let s:I1 = [ '#141413' , '#0a9dff' , 232 , 39  ] " blackestgravel & tardis
let s:I2 = [ '#f4cf86' , '#005fff' , 222 , 27  ] " dirtyblonde    & facebook
let s:I3 = [ '#0a9dff' , '#242321' , 39  , 235 ] " tardis         & darkgravel

let s:V1 = [ '#141413' , '#ffa724' , 232 , 214 ] " blackestgravel & orange
let s:V2 = [ '#000000' , '#fade3e' , 16  , 221 ] " coal           & dalespale
let s:V3 = [ '#000000' , '#b88853' , 16  , 137 ] " coal           & toffee
let s:V4 = [ '#c7915b' , 173 ]                   " coffee

let s:PA = [ '#f4cf86' , 222 ]                   " dirtyblonde
let s:RE = [ '#ff9eb8' , 211 ]                   " dress

let s:file = [ '#ff2c4b' , s:N3[1] , 196     , s:N3[3] , '' ]
let s:IA   = [ s:N2[1]   , s:N3[1] , s:N2[3] , s:N3[3] , '' ]


let g:airline#themes#badwolf#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)
let g:airline#themes#badwolf#normal_modified = {
      \ 'mode_separator' : [ s:N1[1]   , s:N4[0]   , s:N1[3]   , s:N4[1]   , 'bold' ] ,
      \ 'info'           : [ s:N2[0]   , s:N4[0]   , s:N2[2]   , s:N4[1]   , ''     ] ,
      \ 'info_separator' : [ s:N4[0]   , s:N2[1]   , s:N4[1]   , s:N2[3]   , 'bold' ] ,
      \ 'statusline'     : [ s:V1[1]   , s:N2[1]   , s:V1[3]   , s:N2[3]   , ''     ] }


let g:airline#themes#badwolf#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
let g:airline#themes#badwolf#insert_modified = {
      \ 'info_separator' : [ s:I2[1]   , s:N2[1]   , s:I2[3]   , s:N2[3]   , 'bold' ] ,
      \ 'statusline'     : [ s:V1[1]   , s:N2[1]   , s:V1[3]   , s:N2[3]   , ''     ] }
let g:airline#themes#badwolf#insert_paste = {
      \ 'mode'           : [ s:I1[0]   , s:PA[0]   , s:I1[2]   , s:PA[1]   , ''     ] ,
      \ 'mode_separator' : [ s:PA[0]   , s:I2[1]   , s:PA[1]   , s:I2[3]   , ''     ] }


let g:airline#themes#badwolf#replace = copy(airline#themes#badwolf#insert)
let g:airline#themes#badwolf#replace.mode           = [ s:I1[0] , s:RE[0] , s:I1[2] , s:RE[1] , '' ]
let g:airline#themes#badwolf#replace.mode_separator = [ s:RE[0] , s:I2[1] , s:RE[1] , s:I2[3] , '' ]
let g:airline#themes#badwolf#replace_modified = g:airline#themes#badwolf#insert_modified


let g:airline#themes#badwolf#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
let g:airline#themes#badwolf#visual_modified = {
      \ 'info_separator' : [ s:V2[1]   , s:V4[0]   , s:V2[3]   , s:V4[1]   , 'bold' ] ,
      \ 'statusline'     : [ s:V3[0]   , s:V4[0]   , s:V3[2]   , s:V4[1]   , ''     ] }


let g:airline#themes#badwolf#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)
