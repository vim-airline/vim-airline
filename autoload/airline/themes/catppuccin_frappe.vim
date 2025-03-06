" =============================================================================
" Filename: autoload/airline/themes/catppuccin_frappe.vim
" Author: tilmaneggers
" License: MIT License
" Last Change: 2023/01/19
"
" =============================================================================

" Original theme colors
let s:rosewater = "#F2D5CF"
let s:flamingo = "#EEBEBE"
let s:pink = "#F4B8E4"
let s:mauve = "#CA9EE6"
let s:red = "#E78284"
let s:maroon = "#EA999C"
let s:peach = "#EF9F76"
let s:yellow = "#E5C890"
let s:green = "#A6D189"
let s:teal = "#81C8BE"
let s:sky = "#99D1DB"
let s:sapphire = "#85C1DC"
let s:blue = "#8CAAEE"
let s:lavender = "#BABBF1"
"
let s:text = "#C6D0F5"
let s:subtext1 = "#B5BFE2"
let s:subtext0 = "#A5ADCE"
let s:overlay2 = "#949CBB"
let s:overlay1 = "#838BA7"
let s:overlay0 = "#737994"
let s:surface2 = "#626880"
let s:surface1 = "#51576D"
let s:surface0 = "#414559"
"
let s:base = "#303446"
let s:mantle = "#292C3C"
let s:crust = "#232634"

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


let g:airline#themes#catppuccin_frappe#palette = {}

let g:airline#themes#catppuccin_frappe#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#catppuccin_frappe#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#catppuccin_frappe#palette.insert_replace = {
	\ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#catppuccin_frappe#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let g:airline#themes#catppuccin_frappe#palette.replace = copy(g:airline#themes#catppuccin_frappe#palette.normal)
let g:airline#themes#catppuccin_frappe#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]

let s:IA = [ s:N1[1] , s:N3[1] , s:N1[3] , s:N3[3] , '' ]
let g:airline#themes#catppuccin_frappe#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)

let g:airline#themes#catppuccin_frappe#palette.normal.airline_warning = s:WR
let g:airline#themes#catppuccin_frappe#palette.insert.airline_warning = s:WR
let g:airline#themes#catppuccin_frappe#palette.visual.airline_warning = s:WR
