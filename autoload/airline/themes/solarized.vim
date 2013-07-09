let g:airline#themes#solarized#inactive = { 'mode': [ '#073642' , '#586e75' , 235 , 240 , '' ] }

let s:N1 = [ '#fdf6e3' , '#657b83' , 230 , 241 ]
let s:N2 = [ '#fdf6e3' , '#93a1a1' , 230 , 245 ]
let s:N3 = [ '#657b83' , '#fdf6e3' , 241 , 230 ]
let s:NM = {
      \ 'info_separator': [ '#d33682' , '#fdf6e3' , 125     , 230     , ''     ] ,
      \ 'statusline':     [ '#d33682' , '#fdf6e3' , 125     , 230     , ''     ] ,
      \ }
let g:airline#themes#solarized#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#solarized#normal_modified = s:NM
let g:airline#themes#solarized#normal.file = [ '#cb4b16' , s:N3[1] , 166 , s:N3[3] , '' ]


let s:I1 = [ '#fdf6e3' , '#2aa198' , 230 , 37  ]
let g:airline#themes#solarized#insert = airline#themes#generate_color_map(s:I1, s:N2, s:N3)
let g:airline#themes#solarized#insert_modified = s:NM

" I can't find how to customise the paste and replace colors without breaking
" the modified color. If someone knows how they can modify this below.
"let s:IP1 = [ s:I1[0] , '#268bd2' , s:I1[2] , 33 ]
"let g:airline#themes#solarized#insert_paste = airline#themes#generate_color_map(s:IP1, s:I2, s:I3)
"let g:airline#themes#solarized#insert_paste_modified = s:NM
"let s:IR1 = [ s:I1[0] , '#859900' , s:I1[2] , 64 ]
"let g:airline#themes#solarized#insert_replace = airline#themes#generate_color_map(s:IR1, s:I2, s:I3)
"let g:airline#themes#solarized#insert_replace_modified = s:NM

let s:V1 = [ '#fdf6e3' , '#6c71c4' , 230 , 61  ]
let g:airline#themes#solarized#visual = airline#themes#generate_color_map(s:V1, s:N2, s:N3)
let g:airline#themes#solarized#visual_modified = s:NM

