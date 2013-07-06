let s:N1 = [ '#ffffff' , '#005fff' , 255 , 27  ]
let s:N2 = [ '#000087' , '#00dfff' , 18  , 45  ]
let s:N3 = [ '#005fff' , '#afffff' , 27  , 159 ]
let g:airline#themes#light#normal = {
      \ 'mode':           [ s:N1[0]   , s:N1[1]   , s:N1[2] , s:N1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:N1[1]   , s:N2[1]   , s:N1[3] , s:N2[3] , 'bold' ] ,
      \ 'info':           [ s:N2[0]   , s:N2[1]   , s:N2[2] , s:N2[3] , ''     ] ,
      \ 'info_separator': [ s:N2[1]   , s:N3[1]   , s:N2[3] , s:N3[3] , 'bold' ] ,
      \ 'statusline':     [ s:N3[0]   , s:N3[1]   , s:N3[2] , s:N3[3] , ''     ] ,
      \ 'file':           [ '#df0000' , '#ffffff' , 160     , 255     , ''     ] ,
      \ 'inactive':       [ '#9e9e9e' , '#ffffff' , 247     , 255     , ''     ] ,
      \ }
let g:airline#themes#light#normal_modified = {
      \ 'info_separator': [ '#00dfff' , '#ffdfdf' , 45      , 224     , ''     ] ,
      \ 'statusline':     [ '#df0000' , '#ffdfdf' , 160     , 224     , ''     ] ,
      \ }

let s:I1 = [ '#ffffff' , '#00875f' , 255 , 29  ]
let s:I2 = [ '#005f00' , '#00df87' , 22  , 42  ]
let s:I3 = [ '#005f5f' , '#afff87' , 23  , 156 ]
let g:airline#themes#light#insert = {
      \ 'mode':           [ s:I1[0]   , s:I1[1]   , s:I1[2] , s:I1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:I1[1]   , s:I2[1]   , s:I1[3] , s:I2[3] , 'bold' ] ,
      \ 'info':           [ s:I2[0]   , s:I2[1]   , s:I2[2] , s:I2[3] , ''     ] ,
      \ 'info_separator': [ s:I2[1]   , s:I3[1]   , s:I2[3] , s:I3[3] , 'bold' ] ,
      \ 'statusline':     [ s:I3[0]   , s:I3[1]   , s:I3[2] , s:I3[3] , ''     ] ,
      \ }
let g:airline#themes#light#insert_modified = {
      \ 'info_separator': [ '#00df87' , '#ffdfdf' , 42      , 224     , ''     ] ,
      \ 'statusline':     [ '#df0000' , '#ffdfdf' , 160     , 224     , ''     ] ,
      \ }

let s:V1 = [ '#ffffff' , '#ff5f00' , 255 , 202 ]
let s:V2 = [ '#5f0000' , '#ffaf00' , 52  , 214 ]
let s:V3 = [ '#df5f00' , '#ffff87' , 166 , 228 ]
let g:airline#themes#light#visual = {
      \ 'mode':           [ s:V1[0]   , s:V1[1]   , s:V1[2] , s:V1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:V1[1]   , s:V2[1]   , s:V1[3] , s:V2[3] , 'bold' ] ,
      \ 'info':           [ s:V2[0]   , s:V2[1]   , s:V2[2] , s:V2[3] , ''     ] ,
      \ 'info_separator': [ s:V2[1]   , s:V3[1]   , s:V2[3] , s:V3[3] , 'bold' ] ,
      \ 'statusline':     [ s:V3[0]   , s:V3[1]   , s:V3[2] , s:V3[3] , ''     ] ,
      \ }
let g:airline#themes#light#visual_modified = {
      \ 'info_separator': [ '#ffaf00' , '#ffdfdf' , 214     , 224     , ''     ] ,
      \ 'statusline':     [ '#df0000' , '#ffdfdf' , 160     , 224     , ''     ] ,
      \ }
