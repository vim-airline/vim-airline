let s:theme = 'regular'

let s:gui_white = '#ffffff'
let s:gui_black = '#000000'

let s:palette = {}
let s:palette.normal = {
    \ 'airline_a' : [ s:gui_white, s:gui_black, 255, 239 ],
    \ 'airline_b' : [ s:gui_white, s:gui_black, 254, 236 ],
    \ 'airline_c' : [ s:gui_white, s:gui_black, 254, 234 ],
    \ 'airline_x' : [ s:gui_white, s:gui_black, 254, 234 ],
    \ 'airline_y' : [ s:gui_white, s:gui_black, 246, 234 ],
    \ 'airline_z' : [ s:gui_white, s:gui_black, 255, 239 ],
    \ 'airline_error' : [ s:gui_white, s:gui_black, 203, 237 ],
    \ 'airline_warning' : [ s:gui_white, s:gui_black, 215, 237 ]
    \}

let s:palette.insert = s:palette.normal
let s:palette.insert = {
    \ 'airline_a' : [ s:gui_white, s:gui_black, 234, 110 ],
    \ 'airline_c' : [ s:gui_white, s:gui_black, 110, 234 ]
    \}

let s:palette.replace = s:palette.normal
let s:palette.replace = {
    \ 'airline_a' : [ s:gui_white, s:gui_black, 234, 174 ],
    \ 'airline_c' : [ s:gui_white, s:gui_black, 174, 234 ]
    \}

let s:palette.visual = s:palette.normal
let s:palette.visual = {
    \ 'airline_a' : [ s:gui_white, s:gui_black, 234, 182 ],
    \ 'airline_c' : [ s:gui_white, s:gui_black, 182, 234 ]
    \}

let s:palette.inactive = {
    \ 'airline_a' : [ s:gui_white, s:gui_black, 255, 239 ],
    \ 'airline_b' : [ s:gui_white, s:gui_black, 254, 236 ],
    \ 'airline_c' : [ s:gui_white, s:gui_black, 254, 234 ],
    \ 'airline_x' : [ s:gui_white, s:gui_black, 254, 234 ],
    \ 'airline_y' : [ s:gui_white, s:gui_black, 246, 234 ],
    \ 'airline_z' : [ s:gui_white, s:gui_black, 255, 239 ],
    \ 'airline_error' : [ s:gui_white, s:gui_black, 203, 237 ],
    \ 'airline_warning' : [ s:gui_white, s:gui_black, 215, 237 ]
    \}

let g:airline#themes#{s:theme}#palette = s:palette
