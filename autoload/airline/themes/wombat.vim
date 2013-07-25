" vim-airline companion theme of Wombat
" looks great with wombat256 vim colorscheme

" Normal mode
"          [ guifg, guibg, ctermfg, ctermbg, opts ]
let s:N1 = [ '#141413' , '#CAE682' , 232 , 192 ] " mode
let s:N2 = [ '#CAE682' , '#32322F' , 192 , 236 ] " info
let s:N3 = [ '#CAE682' , '#242424' , 192 , 234 ] " statusline
let s:N4 = [ '#86CD74' , 113 ]                   " mode modified

" Insert mode
let s:I1 = [ '#141413' , '#FDE76E' , 232 , 227 ]
let s:I2 = [ '#FDE76E' , '#32322F' , 227 , 236 ]
let s:I3 = [ '#FDE76E' , '#242424' , 227 , 234 ]
let s:I4 = [ '#FADE3E' , 221 ]

" Visual mode
let s:V1 = [ '#141413' , '#B5D3F3' , 232 , 153 ]
let s:V2 = [ '#B5D3F3' , '#32322F' , 153 , 236 ]
let s:V3 = [ '#B5D3F3' , '#242424' , 153 , 234 ]
let s:V4 = [ '#7CB0E6' , 111 ]

" Replace mode
let s:R1 = [ '#141413' , '#E5786D' , 232 , 173 ]
let s:R2 = [ '#E5786D' , '#32322F' , 173 , 236 ]
let s:R3 = [ '#E5786D' , '#242424' , 173 , 234 ]
let s:R4 = [ '#E55345' , 203 ]

" Paste mode
let s:PA = [ '#94E42C' , 47 ]

" Info modified
let s:IM = [ '#40403C' , 238 ]

" File permissions (RO, etc)
let s:file = [ '#E5786D' , s:N3[1] , 203 , s:N3[3] , '' ]

" Inactive mode
let s:IA = [ '#767676' , s:N3[1] , 243 , s:N3[3] , '' ]


let g:airline#themes#wombat#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)
let g:airline#themes#wombat#normal_modified = {
    \ 'mode'           : [ s:N1[0] , s:N4[0] , s:N1[2] , s:N4[1] , ''     ] ,
    \ 'mode_separator' : [ s:N4[0] , s:IM[0] , s:N4[1] , s:IM[1] , 'bold' ] ,
    \ 'info'           : [ s:N4[0] , s:IM[0] , s:N4[1] , s:IM[1] , ''     ] ,
    \ 'info_separator' : [ s:IM[0] , s:N3[1] , s:IM[1] , s:N3[3] , 'bold' ] ,
    \ 'statusline'     : [ s:N4[0] , s:N3[1] , s:N4[1] , s:N3[3] , ''     ] }


let g:airline#themes#wombat#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
let g:airline#themes#wombat#insert_modified = {
    \ 'mode'           : [ s:I1[0] , s:I4[0] , s:I1[2] , s:I4[1] , ''     ] ,
    \ 'mode_separator' : [ s:I4[0] , s:IM[0] , s:I4[1] , s:IM[1] , 'bold' ] ,
    \ 'info'           : [ s:I4[0] , s:IM[0] , s:I4[1] , s:IM[1] , ''     ] ,
    \ 'info_separator' : [ s:IM[0] , s:N3[1] , s:IM[1] , s:N3[3] , 'bold' ] ,
    \ 'statusline'     : [ s:I4[0] , s:N3[1] , s:I4[1] , s:N3[3] , ''     ] }


let g:airline#themes#wombat#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
let g:airline#themes#wombat#visual_modified = {
    \ 'mode'           : [ s:V1[0] , s:V4[0] , s:V1[2] , s:V4[1] , ''     ] ,
    \ 'mode_separator' : [ s:V4[0] , s:IM[0] , s:V4[1] , s:IM[1] , 'bold' ] ,
    \ 'info'           : [ s:V4[0] , s:IM[0] , s:V4[1] , s:IM[1] , ''     ] ,
    \ 'info_separator' : [ s:IM[0] , s:N3[1] , s:IM[1] , s:N3[3] , 'bold' ] ,
    \ 'statusline'     : [ s:V4[0] , s:N3[1] , s:V4[1] , s:N3[3] , ''     ] }


let g:airline#themes#wombat#replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3, s:file)
let g:airline#themes#wombat#replace_modified = {
    \ 'mode'           : [ s:R1[0] , s:R4[0] , s:R1[2] , s:R4[1] , ''     ] ,
    \ 'mode_separator' : [ s:R4[0] , s:IM[0] , s:R4[1] , s:IM[1] , 'bold' ] ,
    \ 'info'           : [ s:R4[0] , s:IM[0] , s:R4[1] , s:IM[1] , ''     ] ,
    \ 'info_separator' : [ s:IM[0] , s:N3[1] , s:IM[1] , s:N3[3] , 'bold' ] ,
    \ 'statusline'     : [ s:R4[0] , s:N3[1] , s:R4[1] , s:N3[3] , ''     ] }


let g:airline#themes#wombat#insert_paste = {
    \ 'mode'           : [ s:I1[0] , s:PA[0] , s:I1[2] , s:PA[1] , ''     ] ,
    \ 'mode_separator' : [ s:PA[0] , s:IM[0] , s:PA[1] , s:IM[1] , 'bold' ] ,
    \ 'info'           : [ s:PA[0] , s:IM[0] , s:PA[1] , s:IM[1] , ''     ] ,
    \ 'info_separator' : [ s:IM[0] , s:N3[1] , s:IM[1] , s:N3[3] , 'bold' ] ,
    \ 'statusline'     : [ s:PA[0] , s:N3[1] , s:PA[1] , s:N3[3] , ''     ] }


let g:airline#themes#wombat#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)
let g:airline#themes#wombat#inactive_modified = {
    \ 'statusline' : [ '#BCBCBC' , '' , 250 , '' , '' ] }
