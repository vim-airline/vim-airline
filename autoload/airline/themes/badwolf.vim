let g:airline#themes#badwolf#normal = {
      \ 'mode':           [ '#141413' , '#aeee00' , 232 , 154 , 'bold' ] ,
      \ 'mode_separator': [ '#aeee00' , '#45413b' , 154 , 238 , 'bold' ] ,
      \ 'info':           [ '#f4cf86' , '#45413b' , 222 , 238 , ''     ] ,
      \ 'info_separator': [ '#45413b' , '#242321' , 238 , 235 , 'bold' ] ,
      \ 'statusline':     [ '#8cffba' , '#242321' , 121 , 235 , ''     ] ,
      \ 'statusline_nc':  [ '#000000' , '#242321' , 16  , 235 , ''     ] ,
      \ 'file':           [ '#ff2c4b' , '#242321' , 196 , 235 , ''     ] ,
      \ 'inactive':       [ '#45413b' , '#242321' , 238 , 235 , ''     ] ,
      \ }
let g:airline#themes#badwolf#normal_modified = copy(g:airline#themes#badwolf#normal)
let g:airline#themes#badwolf#normal_modified.mode_separator = [ '#aeee00' , '#666462' , 154 , 241 , 'bold' ]
let g:airline#themes#badwolf#normal_modified.info           = [ '#f4cf86' , '#666462' , 222 , 241 , '' ]
let g:airline#themes#badwolf#normal_modified.info_separator = [ '#666462' , '#45413b' , 241 , 238 , 'bold' ]
let g:airline#themes#badwolf#normal_modified.statusline     = [ '#ffa724' , '#45413b' , 214 , 238 , '' ]
let g:airline#themes#badwolf#normal_modified.inactive       = [ '#88633f' , '#45413b' , 95  , 238 , '' ]

let g:airline#themes#badwolf#insert = {
      \ 'mode':           [ '#141413' , '#0a9dff' , 232 , 39  , 'bold' ] ,
      \ 'mode_separator': [ '#0a9dff' , '#005fff' , 39  , 27  , 'bold' ] ,
      \ 'info':           [ '#f4cf86' , '#005fff' , 222 , 27  , ''     ] ,
      \ 'info_separator': [ '#005fff' , '#242321' , 27  , 235 , 'bold' ] ,
      \ 'statusline':     [ '#0a9dff' , '#242321' , 39  , 235 , ''     ] ,
      \ }
let g:airline#themes#badwolf#insert_modified = copy(g:airline#themes#badwolf#insert)
let g:airline#themes#badwolf#insert_modified.info_separator = [ '#005fff' , '#45413b' , 27  , 238 , 'bold' ]
let g:airline#themes#badwolf#insert_modified.statusline     = [ '#ffa724' , '#45413b' , 214 , 238 , '' ]

let g:airline#themes#badwolf#visual = {
      \ 'mode':           [ '#141413' , '#ffa724' , 232 , 214 , 'bold' ] ,
      \ 'mode_separator': [ '#ffa724' , '#fade3e' , 214 , 221 , 'bold' ] ,
      \ 'info':           [ '#000000' , '#fade3e' , 16  , 221 , ''     ] ,
      \ 'info_separator': [ '#fade3e' , '#b88853' , 221 , 137 , 'bold' ] ,
      \ 'statusline':     [ '#000000' , '#b88853' , 16  , 137 , ''     ] ,
      \ }
let g:airline#themes#badwolf#visual_modified = copy(g:airline#themes#badwolf#visual)
let g:airline#themes#badwolf#visual_modified.info_separator = [ '#fade3e' , '#c7915b' , 221 , 173 , 'bold' ]
let g:airline#themes#badwolf#visual_modified.statusline     = [ '#000000' , '#c7915b' , 16  , 173 , '' ]
