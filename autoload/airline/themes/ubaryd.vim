" vim-airline companion theme of Ubaryd
" (https://github.com/Donearm/Ubaryd)

" Normal mode
let s:N1 = [ '#141413' , '#c7b386' , 232 , 252 ] " blackestgravel & bleaksand
let s:N2 = [ '#c7b386' , '#45413b' , 252, 238 ] " bleaksand & deepgravel
let s:N3 = [ '#b88853' , '#242321' , 137, 235 ] " toffee & darkgravel
let s:N4 = [ '#857f78' , 243 ] " gravel

" Insert mode
let s:I1 = [ '#1a1a18' , '#fade3e' , 232 , 221 ] " blackestgravel & warmcorn
let s:I2 = [ '#c7b386' , '#45413b' , 252 , 238 ] " bleaksand & deepgravel
let s:I3 = [ '#f4cf86' , '#242321' , 222 , 235 ] " lighttannedskin & darkgravel
 
" Visual mode
let s:V1 = [ '#1c1b1a' , '#9a4820' , 233 , 88 ] " blackgravel & warmadobe
let s:V2 = [ '#000000' , '#88633f' , 16 , 95 ] " coal & cappuccino
let s:V3 = [ '#88633f' , '#c7b386' , 95 , 252 ] " cappuccino & bleaksand
let s:V4 = [ '#c14c3d' , 160 ] " tannedumbrella

" Replace mode
let s:RE = [ '#c7915b' , 173 ] " nut

" Paste mode 
let s:PA = [ '#f9ef6d' , 154 ] " bleaklemon

let s:file = [ '#ff7400' , s:N3[1] , 196 , s:N3[3] , '' ]
let s:IA = [ s:N2[1]	, s:N3[1]	, s:N2[3],	s:N3[3]	, '' ]	


let g:airline#themes#ubaryd#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)
let g:airline#themes#ubaryd#normal_modified = {
      \ 'mode_separator' : [ s:N1[1] , s:N4[0] , s:N1[3] , s:N4[1] , 'bold' ] ,
      \ 'info' : [ s:N2[0] , s:N4[0] , s:N2[2] , s:N4[1] , '' ] ,
      \ 'info_separator' : [ s:N4[0] , s:N2[1] , s:N4[1] , s:N2[3] , 'bold' ] ,
      \ 'statusline' : [ s:V1[1] , s:N2[1] , s:V1[3] , s:N2[3] , '' ] }
let g:airline#themes#ubaryd#inactive = {
      \ 'mode' : [ s:N2[1] , s:N3[1] , s:N2[3] , s:N3[3] , '' ] }


let g:airline#themes#ubaryd#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
let g:airline#themes#ubaryd#insert_modified = {
      \ 'info_separator' : [ s:I2[1] , s:N2[1] , s:I2[3] , s:N2[3] , 'bold' ] ,
      \ 'statusline' : [ s:V2[1] , s:N2[1] , s:V2[3] , s:N2[3] , '' ] }
let g:airline#themes#ubaryd#insert_paste = {
      \ 'mode' : [ s:I1[0] , s:PA[0] , s:I1[2] , s:PA[1] , '' ] ,
      \ 'mode_separator' : [ s:PA[0] , s:I2[1] , s:PA[1] , s:I2[3] , '' ] }


let g:airline#themes#ubaryd#replace = copy(airline#themes#ubaryd#insert)
let g:airline#themes#ubaryd#replace.mode = [ s:I1[0] , s:RE[0] , s:I1[2] , s:RE[1] , '' ]
let g:airline#themes#ubaryd#replace.mode_separator = [ s:RE[0] , s:I2[1] , s:RE[1] , s:V4[1] , '' ]
let g:airline#themes#ubaryd#replace_modified = g:airline#themes#ubaryd#insert_modified


let g:airline#themes#ubaryd#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
let g:airline#themes#ubaryd#visual_modified = {
      \ 'info_separator' : [ s:V2[1] , s:V4[0] , s:V2[3] , s:V4[1] , 'bold' ] ,
      \ 'statusline' : [ s:V3[0] , s:V4[0] , s:V3[2] , s:V4[1] , '' ] }

let g:airline#themes#ubaryd#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)
