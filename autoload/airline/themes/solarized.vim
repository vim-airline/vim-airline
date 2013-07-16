""""""""""""""""""""""""""""""""""""""""""""""""
" Options
""""""""""""""""""""""""""""""""""""""""""""""""
let s:reduced = get(g:, 'airline_solarized_reduced', 1)
let s:background = get(g:, 'airline_solarized_bg', &background)

""""""""""""""""""""""""""""""""""""""""""""""""
" Colors
""""""""""""""""""""""""""""""""""""""""""""""""
" Base colors
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
let s:c218    = {'t': 218, 'g': '#ffafd7'}
let s:c52     = {'t': 52,  'g': '#5f0000'}

""""""""""""""""""""""""""""""""""""""""""""""""
" Simple mappings
" NOTE: These are easily tweakable mappings. The actual mappings get
" the specific gui and terminal colors from the base color dicts.
""""""""""""""""""""""""""""""""""""""""""""""""
" Normal mode
let s:N1 = [s:base2, s:blue, 'bold']
let s:N2 = [s:base2, s:base01, '']
if s:background == 'dark'
    let s:N3 = [s:base1, s:base02, '']
else
    let s:N3 = [s:base00, s:base2, '']
endif
let s:NF = [s:orange, s:N3[1], '']
if s:reduced
    if s:background == 'dark'
        let s:NM = {
                    \ 'info_separator': [s:N2[1], s:N3[1], ''],
                    \ 'statusline': [s:magenta, s:N3[1], ''],
                    \ }
    else
        let s:NM = {
                    \ 'info_separator': [s:N2[1], s:N3[1], ''],
                    \ 'statusline': [s:magenta, s:N3[1], ''],
                    \ }
    endif
else
    if s:background == 'dark'
        let s:NM = {
                    \ 'info_separator':  [s:N2[1], s:c52, ''],
                    \ 'statusline': [s:c218, s:c52, '']
                    \ }
    else
        let s:NM = {
                    \ 'info_separator': [s:N2[1], s:c218, ''],
                    \ 'statusline': [s:red, s:c218, '']
                    \ }
    endif
endif


" Insert mode
let s:I1 = [s:N1[0], s:green, 'bold']
if s:reduced
    let s:I2 = s:N2
else
    let s:I2 = [s:base3, s:base1, '']
endif
let s:I3 = s:N3
let s:IF = s:NF
if s:reduced
    let s:IM = s:NM
else
    let s:IM = {
                \ 'info_separator': [s:I2[1], s:NM.statusline[1], ''],
                \ 'statusline': s:NM.statusline
                \ }
endif

" Visual mode
let s:V1 = [s:N1[0], s:orange, 'bold']
if s:reduced
    let s:V2 = s:N2
    let s:V3 = s:N3
else
    let s:V2 = s:I2
    let s:V3 = s:I3
endif
let s:VF = s:NF
if s:reduced
    let s:VM = s:NM
else
    let s:VM = s:IM
endif

" Inactive
if s:background == 'dark'
    let s:IA = [s:base00, s:base02, '']
else
    let s:IA = [s:base1, s:base2, '']
endif

""""""""""""""""""""""""""""""""""""""""""""""""
" Actual mappings
" WARNING: Don't modify this section unless necessary.
""""""""""""""""""""""""""""""""""""""""""""""""
let s:NFa = [s:NF[0].g, s:NF[1].g, s:NF[0].t, s:NF[1].t, s:NF[2]]
let s:IFa = [s:IF[0].g, s:IF[1].g, s:IF[0].t, s:IF[1].t, s:IF[2]]
let s:VFa = [s:VF[0].g, s:VF[1].g, s:VF[0].t, s:VF[1].t, s:VF[2]]

let g:airline#themes#solarized#inactive = airline#themes#generate_color_map(
            \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]],
            \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]],
            \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]],
            \ s:NFa)

let g:airline#themes#solarized#inactive_modified = {
            \ 'statusline': [s:NM.statusline[0].g, '', s:NM.statusline[0].t, '', ''] }

let g:airline#themes#solarized#normal = airline#themes#generate_color_map(
            \ [s:N1[0].g, s:N1[1].g, s:N1[0].t, s:N1[1].t, s:N1[2]],
            \ [s:N2[0].g, s:N2[1].g, s:N2[0].t, s:N2[1].t, s:N2[2]],
            \ [s:N3[0].g, s:N3[1].g, s:N3[0].t, s:N3[1].t, s:N3[2]],
            \ s:NFa)

let g:airline#themes#solarized#normal_modified = {
            \ 'info_separator': [s:NM.info_separator[0].g, s:NM.info_separator[1].g,
            \ s:NM.info_separator[0].t, s:NM.info_separator[1].t, s:NM.info_separator[2]],
            \ 'statusline': [s:NM.statusline[0].g, s:NM.statusline[1].g,
            \ s:NM.statusline[0].t, s:NM.statusline[1].t, s:NM.statusline[2]]}

let g:airline#themes#solarized#insert = airline#themes#generate_color_map(
            \ [s:I1[0].g, s:I1[1].g, s:I1[0].t, s:I1[1].t, s:I1[2]],
            \ [s:I2[0].g, s:I2[1].g, s:I2[0].t, s:I2[1].t, s:I2[2]],
            \ [s:I3[0].g, s:I3[1].g, s:I3[0].t, s:I3[1].t, s:I3[2]],
            \ s:IFa)

let g:airline#themes#solarized#insert_modified = {
            \ 'info_separator': [s:IM.info_separator[0].g, s:IM.info_separator[1].g,
            \ s:IM.info_separator[0].t, s:IM.info_separator[1].t, s:IM.info_separator[2]],
            \ 'statusline': [s:IM.statusline[0].g, s:IM.statusline[1].g,
            \ s:IM.statusline[0].t, s:IM.statusline[1].t, s:IM.statusline[2]]}

let g:airline#themes#solarized#visual = airline#themes#generate_color_map(
            \ [s:V1[0].g, s:V1[1].g, s:V1[0].t, s:V1[1].t, s:V1[2]],
            \ [s:V2[0].g, s:V2[1].g, s:V2[0].t, s:V2[1].t, s:V2[2]],
            \ [s:V3[0].g, s:V3[1].g, s:V3[0].t, s:V3[1].t, s:V3[2]],
            \ s:VFa)

let g:airline#themes#solarized#visual_modified = {
            \ 'info_separator': [s:VM.info_separator[0].g, s:VM.info_separator[1].g,
            \ s:VM.info_separator[0].t, s:VM.info_separator[1].t, s:VM.info_separator[2]],
            \ 'statusline': [s:VM.statusline[0].g, s:VM.statusline[1].g,
            \ s:VM.statusline[0].t, s:VM.statusline[1].t, s:VM.statusline[2]]}
