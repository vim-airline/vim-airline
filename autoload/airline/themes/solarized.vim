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

let g:airline#themes#solarized#inactive = { 'mode': [ '#073642' , '#586e75' , 235 , 240 , '' ] }

let s:N1 = [ '#fdf6e3' , '#657b83' , 230 , 241 ]
let s:N2 = [ '#fdf6e3' , '#93a1a1' , 230 , 245 ]
let s:N3 = [ '#657b83' , '#fdf6e3' , 241 , 230 ]
let s:NM = {
      \ 'info_separator': [ '#d33682' , '#fdf6e3' , 125     , 230     , ''     ] ,
      \ 'statusline':     [ '#d33682' , '#fdf6e3' , 125     , 230     , ''     ] ,
      \ }
let s:file = [ '#cb4b16' , s:N3[1] , 166 , s:N3[3] ]


let g:airline#themes#solarized#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)
let g:airline#themes#solarized#normal_modified = s:NM


let s:I1 = [ '#fdf6e3' , '#2aa198' , 230 , 37  ]
let g:airline#themes#solarized#insert = airline#themes#generate_color_map(s:I1, s:N2, s:N3, s:file)
let g:airline#themes#solarized#insert_modified = s:NM


" I can't find how to customise the paste and replace colors without breaking
" the modified color. If someone knows how they can modify this below.
"let s:IP1 = [ s:I1[0] , '#268bd2' , s:I1[2] , 33 ]
"let g:airline#themes#solarized#insert_paste = airline#themes#generate_color_map(s:IP1, s:I2, s:I3, s:file)
"let g:airline#themes#solarized#insert_paste_modified = s:NM


let s:IR1 = [ s:I1[0] , '#859900' , s:I1[2] , 64 ]
let g:airline#themes#solarized#replace = airline#themes#generate_color_map(s:IR1, s:N2, s:N3, s:file)
let g:airline#themes#solarized#replace_modified = s:NM


let s:V1 = [ '#fdf6e3' , '#6c71c4' , 230 , 61  ]
let g:airline#themes#solarized#visual = airline#themes#generate_color_map(s:V1, s:N2, s:N3, s:file)
let g:airline#themes#solarized#visual_modified = s:NM

