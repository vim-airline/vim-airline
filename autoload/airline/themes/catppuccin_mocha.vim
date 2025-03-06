" =============================================================================
" Filename: autoload/airline/themes/catppuccin_mocha.vim
" Author: tilmaneggers
" License: MIT License
" Last Change: 2023/01/19
"
" =============================================================================

" Original theme colors
let s:rosewater = "#F5E0DC"
let s:flamingo = "#F2CDCD"
let s:pink = "#F5C2E7"
let s:mauve = "#CBA6F7"
let s:red = "#F38BA8"
let s:maroon = "#EBA0AC"
let s:peach = "#FAB387"
let s:yellow = "#F9E2AF"
let s:green = "#A6E3A1"
let s:teal = "#94E2D5"
let s:sky = "#89DCEB"
let s:sapphire = "#74C7EC"
let s:blue = "#89B4FA"
let s:lavender = "#B4BEFE"
"
let s:text = "#CDD6F4"
let s:subtext1 = "#BAC2DE"
let s:subtext0 = "#A6ADC8"
let s:overlay2 = "#9399B2"
let s:overlay1 = "#7F849C"
let s:overlay0 = "#6C7086"
let s:surface2 = "#585B70"
let s:surface1 = "#45475A"
let s:surface0 = "#313244"
"
let s:base = "#1E1E2E"
let s:mantle = "#181825"
let s:crust = "#11111B"

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


let g:airline#themes#catppuccin_mocha#palette = {}

let g:airline#themes#catppuccin_mocha#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#catppuccin_mocha#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#catppuccin_mocha#palette.insert_replace = {
	\ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#catppuccin_mocha#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let g:airline#themes#catppuccin_mocha#palette.replace = copy(g:airline#themes#catppuccin_mocha#palette.normal)
let g:airline#themes#catppuccin_mocha#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]

let s:IA = [ s:N1[1] , s:N3[1] , s:N1[3] , s:N3[3] , '' ]
let g:airline#themes#catppuccin_mocha#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)

let g:airline#themes#catppuccin_mocha#palette.normal.airline_warning = s:WR
let g:airline#themes#catppuccin_mocha#palette.insert.airline_warning = s:WR
let g:airline#themes#catppuccin_mocha#palette.visual.airline_warning = s:WR
