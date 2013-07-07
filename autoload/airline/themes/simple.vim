let s:powerline = 0
if exists('g:airline_powerline_fonts') && g:airline_powerline_fonts
  let s:powerline = 1

  let s:left = 0
  function! airline#themes#simple#left()
    if s:left == 1
      let s:left = 0
      return ''
    else
      let s:left = 1
      return ''
    endif
  endfunction
  let g:airline_left_sep = '%{airline#themes#simple#left()}'

  let s:right = 0
  function! airline#themes#simple#right()
    if s:right == 1
      let s:right = 0
      return ''
    else
      let s:right = 1
      return ''
    endif
  endfunction
  let g:airline_right_sep = '%{airline#themes#simple#right()}'
endif

let s:bg = 232
let s:sepc = 236
let s:sepg = '#303030'

let s:N1 = s:powerline ? [ '#080808' , '#00dfff' , s:bg , 45 ] : [ '#00dfff' , '#080808' , 45 , s:bg ]
let s:N2 = [ '#ff5f00' , '#080808' , 202 , s:bg ]
let s:N3 = [ '#767676' , '#080808' , 243 , s:bg ]
let g:airline#themes#simple#normal = {
      \ 'mode':           [ s:N1[0]   , s:N1[1]   , s:N1[2] , s:N1[3] , 'bold' ] ,
      \ 'mode_separator': s:powerline
                      \ ? [ '#00dfff' , s:N2[1]   , 45      , s:N2[3] , 'bold' ]
                      \ : [ s:sepg    , s:N2[1]   , s:sepc  , s:N2[3] , 'bold' ] ,
      \ 'info':           [ s:N2[0]   , s:N2[1]   , s:N2[2] , s:N2[3] , ''     ] ,
      \ 'info_separator': [ s:sepg    , s:N3[1]   , s:sepc  , s:N3[3] , 'bold' ] ,
      \ 'statusline':     [ s:N3[0]   , s:N3[1]   , s:N3[2] , s:N3[3] , ''     ] ,
      \ 'file':           [ '#ff0000' , '#080808' , 160     , s:bg    , ''     ] ,
      \ 'inactive':       [ '#4e4e4e' , '#080808' , 239     , s:bg    , ''     ] ,
      \ }
let g:airline#themes#simple#normal_modified = {
      \ 'statusline':     [ '#df0000' , '#080808' , 160     , s:bg    , ''     ] ,
      \ }

let s:I1 = s:powerline ? [ '#080808' , '#5fff00' , s:bg , 82 ] : [ '#5fff00' , '#080808' , 82 , s:bg ]
let s:I2 = [ '#ff5f00' , '#080808' , 202 , s:bg ]
let s:I3 = [ '#767676' , '#080808' , 243 , s:bg ]
let g:airline#themes#simple#insert = {
      \ 'mode':           [ s:I1[0]   , s:I1[1] , s:I1[2] , s:I1[3] , 'bold' ] ,
      \ 'mode_separator': s:powerline
                      \ ? [ '#5fff00' , s:I2[1] , 82      , s:I2[3] , 'bold' ]
                      \ : [ s:sepg    , s:I2[1] , s:sepc  , s:I2[3] , 'bold' ] ,
      \ 'info':           [ s:I2[0]   , s:I2[1] , s:I2[2] , s:I2[3] , ''     ] ,
      \ 'info_separator': [ s:sepg    , s:I3[1] , s:sepc  , s:I3[3] , 'bold' ] ,
      \ 'statusline':     [ s:I3[0]   , s:I3[1] , s:I3[2] , s:I3[3] , ''     ] ,
      \ }
let g:airline#themes#simple#insert_modified = copy(g:airline#themes#simple#normal_modified)

let s:V1 = s:powerline ? [ '#080808' , '#dfdf00' , s:bg , 184 ] : [ '#dfdf00' , '#080808' , 184 , s:bg ]
let s:V2 = [ '#ff5f00' , '#080808' , 202 , s:bg ]
let s:V3 = [ '#767676' , '#080808' , 243 , s:bg ]
let g:airline#themes#simple#visual = {
      \ 'mode':           [ s:V1[0]   , s:V1[1] , s:V1[2] , s:V1[3] , 'bold' ] ,
      \ 'mode_separator': s:powerline
                      \ ? [ '#dfdf00' , s:V2[1] , 184     , s:V2[3] , 'bold' ]
                      \ : [ s:sepg    , s:V2[1] , s:sepc  , s:V2[3] , 'bold' ] ,
      \ 'info':           [ s:V2[0]   , s:V2[1] , s:V2[2] , s:V2[3] , ''     ] ,
      \ 'info_separator': [ s:sepg    , s:V3[1] , s:sepc  , s:V3[3] , 'bold' ] ,
      \ 'statusline':     [ s:V3[0]   , s:V3[1] , s:V3[2] , s:V3[3] , ''     ] ,
      \ }
let g:airline#themes#simple#visual_modified = copy(g:airline#themes#simple#normal_modified)
