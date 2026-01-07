" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2 tw=80
" Modifications: Maciej Bak, 2020

scriptencoding utf-8

" Airline themes are generated based on the following concepts:
"   * The section of the status line, valid Airline statusline sections are:
"       * airline_a (left most section)
"       * airline_b (section just to the right of airline_a)
"       * airline_c (section just to the right of airline_b)
"       * airline_x (first section of the right most sections)
"       * airline_y (section just to the right of airline_x)
"       * airline_z (right most section)
"   * The mode of the buffer, as reported by the :mode() function.  Airline
"     converts the values reported by mode() to the following:
"       * normal
"       * insert
"       * replace
"       * visual
"       * inactive
"       * terminal
"       The last one is actually no real mode as returned by mode(), but used by
"       airline to style inactive statuslines (e.g. windows, where the cursor
"       currently does not reside in).
"   * In addition to each section and mode specified above, airline themes
"     can also specify overrides.  Overrides can be provided for the following
"     scenarios:
"       * 'modified'
"       * 'paste'
"
" Airline themes are specified as a global viml dictionary using the above
" sections, modes and overrides as keys to the dictionary.  The name of the
" dictionary is significant and should be specified as:
"   * g:airline#themes#<theme_name>#palette
" where <theme_name> is substituted for the name of the theme.vim file where the
" theme definition resides.  Airline themes should reside somewhere on the
" 'runtimepath' where it will be loaded at vim startup, for example:
"   * autoload/airline/themes/theme_name.vim
"
" For this, the dark.vim, theme, this is defined as
let g:airline#themes#dark#palette = {}

" Keys in the dictionary are composed of the mode, and if specified the
" override.  For example:
"   * g:airline#themes#dark#palette.normal
"       * the colors for a statusline while in normal mode
"   * g:airline#themes#dark#palette.normal_modified
"       * the colors for a statusline while in normal mode when the buffer has
"         been modified
"   * g:airline#themes#dark#palette.visual
"       * the colors for a statusline while in visual mode
"
" Values for each dictionary key is an array of color values that should be
" familiar for colorscheme designers:
"   * [guifg, guibg, ctermfg, ctermbg, opts]
" See "help attr-list" for valid values for the "opt" value.
"
" Each theme must provide an array of such values for each airline section of
" the statusline (airline_a through airline_z).  A convenience function,
" airline#themes#generate_color_map() exists to mirror airline_a/b/c to
" airline_x/y/z, respectively.

" The angry_dark.vim theme:
let s:airline_a_normal   = [ '#ffffff' , '#262626' , 255 , 235 ]
let s:airline_b_normal   = [ '#ffffff' , '#262626' , 255 , 235 ]
let s:airline_c_normal   = [ '#ffffff' , '#262626' , 255 , 235 ]
let g:airline#themes#dark#palette.normal = airline#themes#generate_color_map(s:airline_a_normal, s:airline_b_normal, s:airline_c_normal)

let s:airline_a_insert   = [ '#ffffff' , '#262626' , 255 , 235 ]
let s:airline_b_insert   = [ '#ffffff' , '#262626' , 255 , 235 ]
let s:airline_c_insert   = [ '#ffffff' , '#262626' , 255 , 235 ]
let g:airline#themes#dark#palette.insert = airline#themes#generate_color_map(s:airline_a_insert, s:airline_b_insert, s:airline_c_insert)
let g:airline#themes#dark#palette.insert_modified = {
      \ 'airline_c': [ '#ffffff' , '#262626' , 255     , 235      , ''     ] ,
      \ }

let g:airline#themes#dark#palette.terminal = airline#themes#generate_color_map(s:airline_a_insert, s:airline_b_insert, s:airline_c_insert)

let g:airline#themes#dark#palette.replace = copy(g:airline#themes#dark#palette.insert)
let g:airline#themes#dark#palette.replace.airline_a = [ s:airline_b_insert[0]   , '#262626' , s:airline_b_insert[2] , 235     , ''     ]
let g:airline#themes#dark#palette.replace_modified = g:airline#themes#dark#palette.insert_modified

let s:airline_a_visual   = [ '#ffffff' , '#262626' , 255 , 235 ]
let s:airline_b_visual   = [ '#ffffff' , '#262626' , 255 , 235 ]
let s:airline_c_visual   = [ '#ffffff' , '#262626' , 255 , 235 ]
let g:airline#themes#dark#palette.visual = airline#themes#generate_color_map(s:airline_a_visual, s:airline_b_visual, s:airline_c_visual)

let s:airline_a_inactive = [ '#ffffff' , '#262626' , 255 , 235 , '' ]
let s:airline_b_inactive = [ '#ffffff' , '#262626' , 255 , 235 , '' ]
let s:airline_c_inactive = [ '#ffffff' , '#262626' , 255 , 235 , '' ]
let g:airline#themes#dark#palette.inactive = airline#themes#generate_color_map(s:airline_a_inactive, s:airline_b_inactive, s:airline_c_inactive)
