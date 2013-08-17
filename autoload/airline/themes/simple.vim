let s:guibg = '#080808'
let s:guibg2 = '#1c1c1c'
let s:termbg = 232
let s:termbg2= 234

let s:file = [ '#ff0000' , '' , 160 , '' , '' ]
let s:N1 = [ s:guibg , '#00dfff' , s:termbg , 45 ]
let s:N2 = [ '#ff5f00' , s:guibg2, 202 , s:termbg2 ]
let s:N3 = [ '#767676' , s:guibg, 243 , s:termbg]
let g:airline#themes#simple#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)
let g:airline#themes#simple#normal_modified = {
      \ 'airline_c': [ '#df0000' , s:guibg, 160     , s:termbg    , ''     ] ,
      \ }


let s:I1 = [ s:guibg, '#5fff00' , s:termbg , 82 ]
let s:I2 = [ '#ff5f00' , s:guibg2, 202 , s:termbg2 ]
let s:I3 = [ '#767676' , s:guibg, 243 , s:termbg ]
let g:airline#themes#simple#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
let g:airline#themes#simple#insert_modified = copy(g:airline#themes#simple#normal_modified)
let g:airline#themes#simple#insert_paste = {
      \ 'airline_a': [ s:I1[0]   , '#d78700' , s:I1[2] , 172     , ''     ] ,
      \ }


let g:airline#themes#simple#replace = {
      \ 'airline_a': [ s:I1[0]   , '#af0000' , s:I1[2] , 124     , ''     ] ,
      \ }
let g:airline#themes#simple#replace_modified = copy(g:airline#themes#simple#normal_modified)


let s:V1 = [ s:guibg, '#dfdf00' , s:termbg , 184 ]
let s:V2 = [ '#ff5f00' , s:guibg2, 202 , s:termbg2 ]
let s:V3 = [ '#767676' , s:guibg, 243 , s:termbg ]
let g:airline#themes#simple#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
let g:airline#themes#simple#visual_modified = copy(g:airline#themes#simple#normal_modified)


let s:IA = [ '#4e4e4e' , s:guibg , 239 , s:termbg , '' ]
let g:airline#themes#simple#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)

