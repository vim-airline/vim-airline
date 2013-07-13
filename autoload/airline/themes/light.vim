
let s:file = [ '#df0000' , '#ffffff' , 160 , 255 ]
let s:N1 = [ '#ffffff' , '#005fff' , 255 , 27  ]
let s:N2 = [ '#000087' , '#00dfff' , 18  , 45  ]
let s:N3 = [ '#005fff' , '#afffff' , 27  , 159 ]
let g:airline#themes#light#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)
let g:airline#themes#light#normal_modified = {
      \ 'info_separator': [ '#00dfff' , '#ffdfdf' , 45      , 224     , ''     ] ,
      \ 'statusline':     [ '#df0000' , '#ffdfdf' , 160     , 224     , ''     ] ,
      \ }


let s:I1 = [ '#ffffff' , '#00875f' , 255 , 29  ]
let s:I2 = [ '#005f00' , '#00df87' , 22  , 42  ]
let s:I3 = [ '#005f5f' , '#afff87' , 23  , 156 ]
let g:airline#themes#light#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
let g:airline#themes#light#insert_modified = {
      \ 'info_separator': [ '#00df87' , '#ffdfdf' , 42      , 224     , ''     ] ,
      \ 'statusline':     [ '#df0000' , '#ffdfdf' , 160     , 224     , ''     ] ,
      \ }
let g:airline#themes#light#insert_paste = {
      \ 'mode':           [ s:I1[0]   , '#d78700' , s:I1[2] , 172     , ''     ] ,
      \ 'mode_separator': [ '#d78700' , s:I2[1]   , 172     , s:I2[3] , ''     ] ,
      \ }


let g:airline#themes#light#replace = copy(g:airline#themes#light#insert)
let g:airline#themes#light#replace.mode           = [ s:I2[0]   , '#ff0000' , s:I1[2] , 196     , ''     ]
let g:airline#themes#light#replace.mode_separator = [ '#ff0000' , s:I2[1]   , 196     , s:I2[3] , ''     ]
let g:airline#themes#light#replace_modified = g:airline#themes#light#insert_modified


let s:V1 = [ '#ffffff' , '#ff5f00' , 255 , 202 ]
let s:V2 = [ '#5f0000' , '#ffaf00' , 52  , 214 ]
let s:V3 = [ '#df5f00' , '#ffff87' , 166 , 228 ]
let g:airline#themes#light#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
let g:airline#themes#light#visual_modified = {
      \ 'info_separator': [ '#ffaf00' , '#ffdfdf' , 214     , 224     , ''     ] ,
      \ 'statusline':     [ '#df0000' , '#ffdfdf' , 160     , 224     , ''     ] ,
      \ }


let s:IA = [ '#9e9e9e' , '#ffffff' , 247 , 255 , '' ]
let g:airline#themes#light#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)
