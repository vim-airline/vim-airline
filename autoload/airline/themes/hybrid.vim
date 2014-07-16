" vim-airline companion theme of Hybrid
" (https://github.com/w0ng/vim-hybrid)

let g:airline#themes#hybrid#palette = {}

let s:N1   = [ '#000000' , '#90a959' , 16  , 2   ]
let s:N2   = [ '#c5c8c6' , '#373b41' , 15  , 8   ]
let s:N3   = [ '#ffffff' , '#282a2e' , 255 , 'Black' ]
let g:airline#themes#hybrid#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#hybrid#palette.normal_modified = {}

let s:I1 = [ '#000000' , '#6a9fb5' , 16  , 4   ]
let s:I2 = [ '#ffffff' , '#005fff' , 255 , 27  ]
let s:I3 = [ '#ffffff' , '#000080' , 15  , 17  ]
let g:airline#themes#hybrid#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#hybrid#palette.insert_modified = {}
let g:airline#themes#hybrid#palette.insert_paste = {
      \ 'airline_a': [ s:I1[0]   , '#d3935f' , s:I1[2] , 3     , ''     ] ,
      \ }

let s:R1 = [ '#000000' , '#aa759f' , 16  , 5   ]
let s:R2 = s:I2
let s:R3 = s:I3
let g:airline#themes#hybrid#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#hybrid#palette.replace_modified = {}

let s:V1 = [ '#000000' , '#f0c674' , 232 , 11  ]
let s:V2 = [ '#000000' , '#d3935f' , 232 , 3   ]
let s:V3 = [ '#ffffff' , '#5f0000' , 15  , 52  ]
let g:airline#themes#hybrid#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#hybrid#palette.visual_modified = {}


let s:IA1 = [ '#4e4e4e' , '#1c1c1c' , 239 , 234 , '' ]
let s:IA2 = [ '#4e4e4e' , '#262626' , 239 , 235 , '' ]
let s:IA3 = [ '#4e4e4e' , '#303030' , 239 , 236 , '' ]
let g:airline#themes#hybrid#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#hybrid#palette.inactive_modified = {}

let g:airline#themes#hybrid#palette.accents = {
      \ 'red': [ '#ff0000' , '' , 160 , ''  ]
      \ }
