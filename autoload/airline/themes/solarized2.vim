" base solarized colors
let s:base03  = {'t': 234, 'g': '#002b36'}
let s:base02  = {'t': 235, 'g': '#073642'}
let s:base01  = {'t': 240, 'g': '#586e75'}
let s:base00  = {'t': 241, 'g': '#657b83'}
let s:base0   = {'t': 244, 'g': '#839496'}
let s:base1   = {'t': 245, 'g': '#93a1a1'}
let s:base2   = {'t': 254, 'g': '#eee8d5'}
let s:base3   = {'t': 230, 'g': '#fdf6e3'}
let s:yellow  = {'t': 136, 'g': '#b58900'}
let s:orange  = {'t': 166, 'g': '#cb4b16'}
let s:red     = {'t': 160, 'g': '#dc322f'}
let s:magenta = {'t': 125, 'g': '#d33682'}
let s:violet  = {'t': 61,  'g': '#6c71c4'}
let s:blue    = {'t': 33,  'g': '#267bd2'}
let s:cyan    = {'t': 37,  'g': '#2aa198'}
let s:green   = {'t': 64,  'g': '#859900'}

" some extended colors
let s:pinky    = {'t': 218,'g': '#ffafd7'}
let s:darkred  = {'t': 52, 'g': '#5f0000'}

" we can't trust vim in &background, because of it can change
" value of this variable on his own mind (after :hi! Normal ctermbg=232
" &background magically changed to 'light' without a reason).
if index([string(s:base03.t), s:base03.g], synIDattr(synIDtrans(hlID('Normal')), 'bg')) > -1
    let s:background = 'dark'
else
    let s:background = 'light'
end

" normal mode
let s:N1 = [s:base2.g, s:blue.g, s:base2.t, s:blue.t, 'bold']
let s:N2 = [s:base2.g, s:base01.g, s:base2.t, s:base01.t]
if s:background == 'dark'
    let s:N3 = [s:base1.g, s:base02.g, s:base1.t, s:base02.t]
    let s:NF = [s:pinky.g, s:base02.g, s:pinky.t, s:base02.t, '']
else
    let s:N3 = [s:base1.g, s:base2.g, s:base1.t, s:base2.t]
    let s:NF = [s:red.g, s:base2.g, s:red.t, s:base2.t, '']
endif
if s:background == 'dark'
    let s:NM = {
        \ 'info_separator': [s:N2[1], s:N3[1], s:N2[3], s:darkred.t, ''], 
        \ 'statusline': [s:pinky.g, s:darkred.g, s:pinky.t, s:darkred.t, ''], 
        \ }
else
    let s:NM = {
        \ 'info_separator': [s:N2[1], s:N3[1], s:N2[3], s:pinky.t, ''], 
        \ 'statusline': [s:red.g, s:pinky.g, s:red.t, s:pinky.t, ''], 
        \ }
endif

" insert mode
if s:background == 'dark'
    let s:I1 = [s:base2.g, s:blue.g, s:base03.t, s:base3.t, 'bold']
else
    let s:I1 = [s:base3.g, s:orange.g, s:base3.t, s:orange.t, 'bold']
endif
let s:I2 = [s:base3.g, s:base1.g, s:base3.t, s:base1.t]
let s:I3 = s:N3
let s:IM = {
    \ 'info_separator': [s:I2[1], s:I3[1], s:I2[3], s:NM.statusline[3], ''], 
    \ 'statusline': s:NM.statusline
    \ }

" visual mode
let s:V1 = [s:base3.g, s:magenta.g, s:base3.t, s:magenta.t, 'bold']
let s:V2 = s:I2
let s:V3 = s:I3
let s:VM = {
    \ 'info_separator': [s:V2[1], s:V3[1], s:V2[3], s:NM.statusline[3], ''], 
    \ 'statusline': s:NM.statusline
    \ }

" actual mapping goes next
let g:airline#themes#solarized2#inactive = {
    \ 'mode': [s:N3[0], s:N3[1], s:N3[2], s:N3[3], ''], 
    \ }

let g:airline#themes#solarized2#normal =
    \ airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#solarized2#normal_modified =
    \ s:NM

let g:airline#themes#solarized2#normal.file =
    \ s:NF

let g:airline#themes#solarized2#insert =
    \ airline#themes#generate_color_map(s:I1, s:I2, s:I3)

let g:airline#themes#solarized2#insert_modified =
    \ s:IM

let g:airline#themes#solarized2#insert.file =
    \ s:NF

let g:airline#themes#solarized2#visual =
    \ airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let g:airline#themes#solarized2#visual_modified =
    \ s:VM

let g:airline#themes#solarized2#visual.file =
    \ s:NF
