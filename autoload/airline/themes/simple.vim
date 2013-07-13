let s:swap = 0
if exists('g:airline_powerline_fonts') && g:airline_powerline_fonts
  let s:swap = 1

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

if g:airline_left_sep == '' && g:airline_right_sep == ''
  let s:swap = 1
endif

let s:guibg = '#080808'
let s:termbg = 232
let s:termsep = 236
let s:guisep = '#303030'

let s:file = [ '#ff0000' , s:guibg , 160       , s:termbg , ''     ]
let s:N1 = s:swap ? [ s:guibg , '#00dfff' , s:termbg , 45 ] : [ '#00dfff' , s:guibg , 45 , s:termbg ]
let s:N2 = [ '#ff5f00' , s:guibg, 202 , s:termbg ]
let s:N3 = [ '#767676' , s:guibg, 243 , s:termbg ]
let g:airline#themes#simple#normal = {
      \ 'mode':           [ s:N1[0]   , s:N1[1] , s:N1[2]   , s:N1[3]  , 'bold' ] ,
      \ 'mode_separator': s:swap
                      \ ? [ '#00dfff' , s:N2[1] , 45        , s:N2[3]  , 'bold' ]
                      \ : [ s:guisep  , s:N2[1] , s:termsep , s:N2[3]  , 'bold' ] ,
      \ 'info':           [ s:N2[0]   , s:N2[1] , s:N2[2]   , s:N2[3]  , ''     ] ,
      \ 'info_separator': [ s:guisep  , s:N3[1] , s:termsep , s:N3[3]  , 'bold' ] ,
      \ 'statusline':     [ s:N3[0]   , s:N3[1] , s:N3[2]   , s:N3[3]  , ''     ] ,
      \ 'file':           s:file,
      \ }
let g:airline#themes#simple#normal_modified = {
      \ 'statusline':     [ '#df0000' , s:guibg, 160     , s:termbg    , ''     ] ,
      \ }


let s:I1 = s:swap ? [ s:guibg, '#5fff00' , s:termbg , 82 ] : [ '#5fff00' , s:guibg, 82 , s:termbg ]
let s:I2 = [ '#ff5f00' , s:guibg, 202 , s:termbg ]
let s:I3 = [ '#767676' , s:guibg, 243 , s:termbg ]
let g:airline#themes#simple#insert = {
      \ 'mode':           [ s:I1[0]   , s:I1[1] , s:I1[2]   , s:I1[3] , 'bold' ] ,
      \ 'mode_separator': s:swap
                      \ ? [ '#5fff00' , s:I2[1] , 82        , s:I2[3] , 'bold' ]
                      \ : [ s:guisep  , s:I2[1] , s:termsep , s:I2[3] , 'bold' ] ,
      \ 'info':           [ s:I2[0]   , s:I2[1] , s:I2[2]   , s:I2[3] , ''     ] ,
      \ 'info_separator': [ s:guisep  , s:I3[1] , s:termsep , s:I3[3] , 'bold' ] ,
      \ 'statusline':     [ s:I3[0]   , s:I3[1] , s:I3[2]   , s:I3[3] , ''     ] ,
      \ }
let g:airline#themes#simple#insert_modified = copy(g:airline#themes#simple#normal_modified)
let g:airline#themes#simple#insert_paste = {
      \ 'mode':           [ s:I1[0]   , '#d78700' , s:I1[2] , 172     , ''     ] ,
      \ 'mode_separator': [ '#d78700' , s:I2[1]   , 172     , s:I2[3] , ''     ] ,
      \ }


let g:airline#themes#simple#replace = {
      \ 'mode':           [ s:I1[0]   , '#af0000' , s:I1[2] , 124     , ''     ] ,
      \ 'mode_separator': [ '#af0000' , s:I2[1]   , 124     , s:I2[3] , ''     ] ,
      \ }
let g:airline#themes#simple#replace_modified = copy(g:airline#themes#simple#normal_modified)


let s:V1 = s:swap ? [ s:guibg, '#dfdf00' , s:termbg , 184 ] : [ '#dfdf00' , s:guibg, 184 , s:termbg ]
let s:V2 = [ '#ff5f00' , s:guibg, 202 , s:termbg ]
let s:V3 = [ '#767676' , s:guibg, 243 , s:termbg ]
let g:airline#themes#simple#visual = {
      \ 'mode':           [ s:V1[0]   , s:V1[1] , s:V1[2]   , s:V1[3] , 'bold' ] ,
      \ 'mode_separator': s:swap
                      \ ? [ '#dfdf00' , s:V2[1] , 184       , s:V2[3] , 'bold' ]
                      \ : [ s:guisep  , s:V2[1] , s:termsep , s:V2[3] , 'bold' ] ,
      \ 'info':           [ s:V2[0]   , s:V2[1] , s:V2[2]   , s:V2[3] , ''     ] ,
      \ 'info_separator': [ s:guisep  , s:V3[1] , s:termsep , s:V3[3] , 'bold' ] ,
      \ 'statusline':     [ s:V3[0]   , s:V3[1] , s:V3[2]   , s:V3[3] , ''     ] ,
      \ }
let g:airline#themes#simple#visual_modified = copy(g:airline#themes#simple#normal_modified)


let s:IA = [ '#4e4e4e' , s:guibg , 239 , s:termbg , '' ]
let g:airline#themes#simple#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)

