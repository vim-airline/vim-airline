" Revised Powerlineish theme

" Normal mode
let s:N1 = [ '#005f00' , '#afd700' , 22  , 148 ]
let s:N2 = [ '#ffffd7' , '#585858' , 230 , 240 ]
let s:N3 = [ '#ffffff' , '#303030' , 231 , 236 ]

" Insert mode
let s:I1 = [ '#005f5f' , '#ffffff' , 23  , 231 ]
let s:I2 = [ '#ffffd7' , '#0087af' , 230 , 31  ]
let s:I3 = [ '#ffffff' , '#005f87' , 231 , 24  ]

" Visual mode
let s:V1 = [ '#080808' , '#ffaf00' , 232 , 214 ]

" Replace mode
let s:RE = [ '#ffffff' , '#d70000' , 231 , 160 ]

" Inactive
let s:IA = [ s:N2[1] , s:N3[1] , s:N2[3] , s:N3[3] , '' ]

let g:airline#themes#powerlineish2#palette = {}

let g:airline#themes#powerlineish2#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#powerlineish2#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)

let g:airline#themes#powerlineish2#palette.visual = airline#themes#generate_color_map(s:V1, s:N2, s:N3)

let g:airline#themes#powerlineish2#palette.replace = airline#themes#generate_color_map(s:RE, s:I2, s:I3)

let g:airline#themes#powerlineish2#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)

if !get(g:, 'loaded_bufferline', 0)
  finish
endif

let g:airline#themes#powerlineish2#palette.normal.bufferline_selected = [ '#ffffd7' , '#585858' , 231 , 240 ]
let g:airline#themes#powerlineish2#palette.insert.bufferline_selected = [ '#ffffd7' , '#0087af' , 231 , 31  ]
let g:airline#themes#powerlineish2#palette.replace.bufferline_selected = [ '#ffffd7' , '#0087af' , 231 , 31  ]
