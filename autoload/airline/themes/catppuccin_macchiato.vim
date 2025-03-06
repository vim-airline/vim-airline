" =============================================================================
" Filename: autoload/airline/themes/catppuccin_macchiato.vim
" Author: tilmaneggers
" License: MIT License
" Last Change: 2023/01/19
"
" =============================================================================

" Original theme colors
let s:rosewater = "#F4DBD6"
let s:flamingo = "#F0C6C6"
let s:pink = "#F5BDE6"
let s:mauve = "#C6A0F6"
let s:red = "#ED8796"
let s:maroon = "#EE99A0"
let s:peach = "#F5A97F"
let s:yellow = "#EED49F"
let s:green = "#A6DA95"
let s:teal = "#8BD5CA"
let s:sky = "#91D7E3"
let s:sapphire = "#7DC4E4"
let s:blue = "#8AADF4"
let s:lavender = "#B7BDF8"
"
let s:text = "#CAD3F5"
let s:subtext1 = "#B8C0E0"
let s:subtext0 = "#A5ADCB"
let s:overlay2 = "#939AB7"
let s:overlay1 = "#8087A2"
let s:overlay0 = "#6E738D"
let s:surface2 = "#5B6078"
let s:surface1 = "#494D64"
let s:surface0 = "#363A4F"
"
let s:base = "#24273A"
let s:mantle = "#1E2030"
let s:crust = "#181926"

" Normal mode
" (Dark)
let s:N1 = [ s:mantle , s:blue , 59  , 149 ] " guifg guibg ctermfg ctermbg
let s:N2 = [ s:blue , s:surface1 , 149 , 59  ] " guifg guibg ctermfg ctermbg
let s:N3 = [ s:text , s:base , 145 , 16  ] " guifg guibg ctermfg ctermbg

" Insert mode
let s:I1 = [ s:mantle , s:teal , 59  , 74  ] " guifg guibg ctermfg ctermbg
let s:I2 = [ s:teal , s:mantle , 74  , 59  ] " guifg guibg ctermfg ctermbg
let s:I3 = [ s:text , s:base , 145 , 16  ] " guifg guibg ctermfg ctermbg

" Visual mode
let s:V1 = [ s:mantle , s:mauve , 59  , 209 ] " guifg guibg ctermfg ctermbg
let s:V2 = [ s:mauve , s:mantle , 209 , 59  ] " guifg guibg ctermfg ctermbg
let s:V3 = [ s:text , s:base , 145 , 16  ] " guifg guibg ctermfg ctermbg

" Replace mode
let s:RE = [ s:mantle , s:red , 59  , 203 ] " guifg guibg ctermfg ctermbg

" Warning section
let s:WR = [s:mantle ,s:peach , 232, 166 ]


let g:airline#themes#catppuccin_macchiato#palette = {}

let g:airline#themes#catppuccin_macchiato#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#catppuccin_macchiato#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#catppuccin_macchiato#palette.insert_replace = {
	\ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#catppuccin_macchiato#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let g:airline#themes#catppuccin_macchiato#palette.replace = copy(g:airline#themes#catppuccin_macchiato#palette.normal)
let g:airline#themes#catppuccin_macchiato#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]

let s:IA = [ s:N1[1] , s:N3[1] , s:N1[3] , s:N3[3] , '' ]
let g:airline#themes#catppuccin_macchiato#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)

let g:airline#themes#catppuccin_macchiato#palette.normal.airline_warning = s:WR
let g:airline#themes#catppuccin_macchiato#palette.insert.airline_warning = s:WR
let g:airline#themes#catppuccin_macchiato#palette.visual.airline_warning = s:WR
