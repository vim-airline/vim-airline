" SOLARIZED HEX     16/8 TERMCOL  XTERM/HEX   L*A*B      sRGB        HSB
" --------- ------- ---- -------  ----------- ---------- ----------- -----------
" base03    #002b36  8/4 brblack  234 #1c1c1c 15 -12 -12   0  43  54 193 100  21
" base02    #073642  0/4 black    235 #262626 20 -12 -12   7  54  66 192  90  26
" base01    #586e75 10/7 brgreen  240 #4e4e4e 45 -07 -07  88 110 117 194  25  46
" base00    #657b83 11/7 bryellow 241 #585858 50 -07 -07 101 123 131 195  23  51
" base0     #839496 12/6 brblue   244 #808080 60 -06 -03 131 148 150 186  13  59
" base1     #93a1a1 14/4 brcyan   245 #8a8a8a 65 -05 -02 147 161 161 180   9  63
" base2     #eee8d5  7/7 white    254 #d7d7af 92 -00  10 238 232 213  44  11  93
" base3     #fdf6e3 15/7 brwhite  230 #ffffd7 97  00  10 253 246 227  44  10  99
" yellow    #b58900  3/3 yellow   136 #af8700 60  10  65 181 137   0  45 100  71
" orange    #cb4b16  9/3 brred    166 #d75f00 50  50  55 203  75  22  18  89  80
" red       #dc322f  1/1 red      160 #d70000 50  65  45 220  50  47   1  79  86
" magenta   #d33682  5/5 magenta  125 #af005f 50  65 -05 211  54 130 331  74  83
" violet    #6c71c4 13/5 brmagenta 61 #5f5faf 50  15 -45 108 113 196 237  45  77
" blue      #268bd2  4/4 blue      33 #0087ff 55 -10 -45  38 139 210 205  82  82
" cyan      #2aa198  6/6 cyan      37 #00afaf 60 -35 -05  42 161 152 175  74  63
" green     #859900  2/2 green     64 #5f8700 60 -20  65 133 153   0  68 100  60

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
let s:blue    = {'t': 33,  'g': '#268bd2'}
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
        \ 'info_separator': [s:N2[1], s:darkred.g, s:N2[3], s:darkred.t, ''], 
        \ 'statusline': [s:pinky.g, s:darkred.g, s:pinky.t, s:darkred.t, ''], 
        \ }
else
    let s:NM = {
        \ 'info_separator': [s:N2[1], s:pinky.g, s:N2[3], s:pinky.t, ''], 
        \ 'statusline': [s:red.g, s:pinky.g, s:red.t, s:pinky.t, ''], 
        \ }
endif

" insert mode
if s:background == 'dark'
    let s:I1 = [s:base03.g, s:base3.g, s:base03.t, s:base3.t, 'bold']
else
    let s:I1 = [s:base3.g, s:orange.g, s:base3.t, s:orange.t, 'bold']
endif
let s:I2 = [s:base3.g, s:base1.g, s:base3.t, s:base1.t]
let s:I3 = s:N3
let s:IM = {
    \ 'info_separator': [s:I2[1], s:NM.statusline[1], s:I2[3], s:NM.statusline[3], ''], 
    \ 'statusline': s:NM.statusline
    \ }

" visual mode
let s:V1 = [s:base3.g, s:magenta.g, s:base3.t, s:magenta.t, 'bold']
let s:V2 = s:I2
let s:V3 = s:I3
let s:VM = {
    \ 'info_separator': [s:V2[1], s:NM.statusline[1], s:V2[3], s:NM.statusline[3], ''], 
    \ 'statusline': s:NM.statusline
    \ }

" inactive
let s:IA = [s:N3[0], s:N3[1], s:N3[2], s:N3[3], '']

" actual mapping goes next
let g:airline#themes#solarized2#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:IA)


let g:airline#themes#solarized2#normal =
    \ airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:NF)

let g:airline#themes#solarized2#normal_modified =
    \ s:NM


let g:airline#themes#solarized2#insert =
    \ airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:NF)

let g:airline#themes#solarized2#insert_modified =
    \ s:IM


let g:airline#themes#solarized2#replace =
    \ airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:NF)

let g:airline#themes#solarized2#replace_modified =
    \ s:IM


let g:airline#themes#solarized2#visual =
    \ airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:NF)

let g:airline#themes#solarized2#visual_modified =
    \ s:VM
