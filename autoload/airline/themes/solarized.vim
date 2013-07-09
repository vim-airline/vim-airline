let g:airline#themes#solarized#inactive = { 'mode': [ '#4e4e4e' , '#1c1c1c' , 239 , 234 , '' ] }

let s:N1 = [ '#fdf6e3' , '#657b83' , 230 , 241 ]
let s:N2 = [ '#fdf6e3' , '#93a1a1' , 230 , 245 ]
let s:N3 = [ '#657b83' , '#fdf6e3' , 241 , 230 ]
let g:airline#themes#solarized#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#solarized#normal.file = [ '#ff0000' , '#1c1c1c' , 160 , 233 , '' ]

let g:airline#themes#solarized#normal_modified = {
      \ 'info_separator': [ '#444444' , '#5f005f' , 238     , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }

let s:I1 = [ '#073642' , '#d33682' , 235 , 125 ]
let s:I2 = [ '#073642' , '#268bd2' , 235 , 33  ]
let s:I3 = [ '#073642' , '#2aa198' , 235 , 37  ]
let g:airline#themes#solarized#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#solarized#insert_modified = {
      \ 'info_separator': [ '#005fff' , '#5f005f' , 27      , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }

let s:V1 = [ '#002b36' , '#b58900' , 234 , 136 ]
let s:V2 = [ '#073642' , '#cb4b16' , 235 , 166 ]
let s:V3 = [ '#fdf6e3' , '#dc322f' , 230 , 160 ]
let g:airline#themes#solarized#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#solarized#visual_modified = {
      \ 'info_separator': [ '#ff5f00' , '#5f005f' , 202     , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }
