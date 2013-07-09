let s:N1 = [ '#xxxxxx' , '#xxxxxx' , 7  , 4   ]
let s:N2 = [ '#xxxxxx' , '#xxxxxx' , 7  , 10  ]
let s:N3 = [ '#xxxxxx' , '#xxxxxx' , 14 , 7   ]
let g:airline#themes#solarized_light#normal = {
      \ 'mode':           [ s:N1[0]   , s:N1[1]   , s:N1[2] , s:N1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:N1[1]   , s:N2[1]   , s:N1[3] , s:N2[3] , 'bold' ] ,
      \ 'info':           [ s:N2[0]   , s:N2[1]   , s:N2[2] , s:N2[3] , ''     ] ,
      \ 'info_separator': [ s:N2[1]   , s:N3[1]   , s:N2[3] , s:N3[3] , 'bold' ] ,
      \ 'statusline':     [ s:N3[0]   , s:N3[1]   , s:N3[2] , s:N3[3] , ''     ] ,
      \ 'file':           [ '#xxxxxx' , '#xxxxxx' , 160     , s:N3[3] , ''     ] ,
      \ 'inactive':       [ '#xxxxxx' , '#xxxxxx' , 15      , 7       , ''     ] ,
      \ }
let g:airline#themes#solarized_light#normal_modified = {
      \ 'info_separator': [ s:N2[1]   , s:N3[1]   , s:N2[3] , 224     , 'bold' ] ,
      \ 'statusline':     [ '#xxxxxx' , '#xxxxxx' , 160     , 224     , ''     ] ,
      \ }

let s:I1 = [ '#xxxxxx' , '#xxxxxx' , 15 , 9  ]
let s:I2 = [ '#xxxxxx' , '#xxxxxx' , 15 , 14 ]
let s:I3 = [ '#xxxxxx' , '#xxxxxx' , 10 , 7  ]
let g:airline#themes#solarized_light#insert = {
      \ 'mode':           [ s:I1[0]   , s:I1[1]   , s:I1[2] , s:I1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:I1[1]   , s:I2[1]   , s:I1[3] , s:I2[3] , 'bold' ] ,
      \ 'info':           [ s:I2[0]   , s:I2[1]   , s:I2[2] , s:I2[3] , ''     ] ,
      \ 'info_separator': [ s:I2[1]   , s:I3[1]   , s:I2[3] , s:I3[3] , 'bold' ] ,
      \ 'statusline':     [ s:I3[0]   , s:I3[1]   , s:I3[2] , s:I3[3] , ''     ] ,
      \ }
let g:airline#themes#solarized_light#insert_modified = {
      \ 'info_separator': [ s:I2[1]   , s:I3[1]   , s:I2[3] , 224     , 'bold' ] ,
      \ 'statusline':     [ '#xxxxxx' , '#xxxxxx' , 160     , 224     , ''     ] ,
      \ }

let s:V1 = [ '#xxxxxx' , '#xxxxxx' , 15 , 5  ]
let s:V2 = [ '#xxxxxx' , '#xxxxxx' , 15 , 14 ]
let s:V3 = [ '#xxxxxx' , '#xxxxxx' , 10 , 7  ]
let g:airline#themes#solarized_light#visual = {
      \ 'mode':           [ s:V1[0]   , s:V1[1]   , s:V1[2] , s:V1[3] , 'bold' ] ,
      \ 'mode_separator': [ s:V1[1]   , s:V2[1]   , s:V1[3] , s:V2[3] , 'bold' ] ,
      \ 'info':           [ s:V2[0]   , s:V2[1]   , s:V2[2] , s:V2[3] , ''     ] ,
      \ 'info_separator': [ s:V2[1]   , s:V3[1]   , s:V2[3] , s:V3[3] , 'bold' ] ,
      \ 'statusline':     [ s:V3[0]   , s:V3[1]   , s:V3[2] , s:V3[3] , ''     ] ,
      \ }
let g:airline#themes#solarized_light#visual_modified = {
      \ 'info_separator': [ s:V2[1]   , s:V3[1]   , s:V2[3] , 224     , 'bold' ] ,
      \ 'statusline':     [ '#xxxxxx' , '#xxxxxx' , 160     , 224     , ''     ] ,
      \ }

let g:airline#themes#solarized_light#inactive = {
      \ 'mode': [ '#xxxxxx' , '#xxxxxx' , 14 , 7 , '' ],
      \ }
