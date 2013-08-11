" Each theme is contained in its own file and declares variables scoped to the
" file.  These variables represent the possible "modes" that airline can
" detect.  The mode is the return value of mode(), which gets converted to a
" readable string.  The following is a list currently supported modes: normal,
" insert, replace, visual, and inactive.
"
" Each mode can also have overrides.  These are small changes to the mode that
" don't require a completely different look.  "modified" and "paste" are two
" such supported overrides.  These are simply suffixed to the major mode,
" separated by an underscore.  For example, "normal_modified" would be normal
" mode where the current buffer is modified.
"
" The theming algorithm is a 2-pass system where the mode will draw over all
" parts of the statusline, and then the override is applied after.  This means
" it is possible to specify a subset of the theme in overrides, as it will
" simply overwrite the previous colors.  If you want simultaneous overrides,
" then they will need to change different parts of the statusline so they do
" not conflict with each other.

" First let's define some arrays.  The s: is just a VimL thing for scoping the
" variables to the current script.  Without this, these variables would be
" declared globally.
"
" The array is in the format [ guifg, guibg, ctermfg, ctermbg, opts ].
" The opts takes in values from ":help attr-list".
let s:file = [ '#ff0000' , ''        , 160 , ''    , '' ]
let s:N1   = [ '#00005f' , '#dfff00' , 17  , 190 ]
let s:N2   = [ '#ffffff' , '#444444' , 255 , 238 ]
let s:N3   = [ '#9cffd3' , '#202020' , 85  , 234 ]

" vim-airline is made up of multiple sections, but for theming purposes there
" is only 3 sections: the mode, the branch indicator, and the gutter (which
" then get mirrored on the right side).  generate_color_map is a helper
" function which generates a dictionary which declares the full colorscheme
" for the statusline.  See the source code of "autoload/airline/themes.vim"
" for the full set of keys available for theming.

" Now let's define the global g: variable that declares the colors used for
" normal mode.  The # is a separator that maps with the directory structure.
" If you get this wrong, Vim will complain loudly.
let g:airline#themes#dark#normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)

" Here we define overrides for when the buffer is modified.  This will be
" applied after g:airline#themes#dark#normal, hence why only certain keys are
" declared.
let g:airline#themes#dark#normal_modified = {
      \ 'info_separator': [ '#444444' , '#5f005f' , 238     , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }


let s:I1 = [ '#00005f' , '#00dfff' , 17  , 45  ]
let s:I2 = [ '#ffffff' , '#005fff' , 255 , 27  ]
let s:I3 = [ '#ffffff' , '#000080' , 15  , 17  ]
let g:airline#themes#dark#insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
let g:airline#themes#dark#insert_modified = {
      \ 'info_separator': [ '#005fff' , '#5f005f' , 27      , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }
let g:airline#themes#dark#insert_paste = {
      \ 'mode':           [ s:I1[0]   , '#d78700' , s:I1[2] , 172     , ''     ] ,
      \ 'mode_separator': [ '#d78700' , s:I2[1]   , 172     , s:I2[3] , ''     ] ,
      \ }


let g:airline#themes#dark#replace = copy(g:airline#themes#dark#insert)
let g:airline#themes#dark#replace.mode           = [ s:I2[0]   , '#af0000' , s:I2[2] , 124     , ''     ]
let g:airline#themes#dark#replace.mode_separator = [ '#af0000' , s:I2[1]   , 124     , s:I2[3] , ''     ]
let g:airline#themes#dark#replace_modified = g:airline#themes#dark#insert_modified


let s:V1 = [ '#000000' , '#ffaf00' , 232 , 214 ]
let s:V2 = [ '#000000' , '#ff5f00' , 232 , 202 ]
let s:V3 = [ '#ffffff' , '#5f0000' , 15  , 52  ]
let g:airline#themes#dark#visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
let g:airline#themes#dark#visual_modified = {
      \ 'info_separator': [ '#ff5f00' , '#5f005f' , 202     , 53      , ''     ] ,
      \ 'statusline':     [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }


let s:IA = [ '#4e4e4e' , '#1c1c1c' , 239 , 234 , '' ]
let g:airline#themes#dark#inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)


" Here we define the color map for ctrlp.  We check for the g:loaded_ctrlp
" variable so that related functionality is loaded iff the user is using
" ctrlp. Note that this is optional, and if you do not define ctrlp colors
" they will be chosen automatically from the existing palette.
if get(g:, 'loaded_ctrlp', 0)
  let g:airline#themes#dark#ctrlp = airline#extensions#ctrlp#generate_color_map(
        \ [ '#d7d7ff' , '#5f00af' , 189 , 55  , ''     ],
        \ [ '#ffffff' , '#875fd7' , 231 , 98  , ''     ],
        \ [ '#5f00af' , '#ffffff' , 55  , 231 , 'bold' ])
endif
