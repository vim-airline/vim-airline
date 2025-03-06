" =============================================================================
" Filename: autoload/airline/themes/catppuccin_latte.vim
" Author: tilmaneggers
" License: MIT License
" Last Change: 2023/01/19
"
" =============================================================================

" Original theme colors
let s:rosewater = "#dc8a78"
let s:flamingo = "#DD7878"
let s:pink = "#ea76cb"
let s:mauve = "#8839EF"
let s:red = "#D20F39"
let s:maroon = "#E64553"
let s:peach = "#FE640B"
let s:yellow = "#df8e1d"
let s:green = "#40A02B"
let s:teal = "#179299"
let s:sky = "#04A5E5"
let s:sapphire = "#209FB5"
let s:blue = "#1e66f5"
let s:lavender = "#7287FD"
"
let s:text = "#4C4F69"
let s:subtext1 = "#5C5F77"
let s:subtext0 = "#6C6F85"
let s:overlay2 = "#7C7F93"
let s:overlay1 = "#8C8FA1"
let s:overlay0 = "#9CA0B0"
let s:surface2 = "#ACB0BE"
let s:surface1 = "#BCC0CC"
let s:surface0 = "#CCD0DA"
"
let s:base = "#EFF1F5"
let s:mantle = "#E6E9EF"
let s:crust = "#DCE0E8"

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


let g:airline#themes#catppuccin_latte#palette = {}

let g:airline#themes#catppuccin_latte#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#catppuccin_latte#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#catppuccin_latte#palette.insert_replace = {
	\ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#catppuccin_latte#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let g:airline#themes#catppuccin_latte#palette.replace = copy(g:airline#themes#catppuccin_latte#palette.normal)
let g:airline#themes#catppuccin_latte#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]

let s:IA = [ s:N1[1] , s:N3[1] , s:N1[3] , s:N3[3] , '' ]
let g:airline#themes#catppuccin_latte#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)

let g:airline#themes#catppuccin_latte#palette.normal.airline_warning = s:WR
let g:airline#themes#catppuccin_latte#palette.insert.airline_warning = s:WR
let g:airline#themes#catppuccin_latte#palette.visual.airline_warning = s:WR
