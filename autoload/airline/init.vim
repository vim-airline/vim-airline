" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! s:check_defined(variable, default)
  if !exists(a:variable)
    let {a:variable} = a:default
  endif
endfunction

let s:loaded = 0
function! airline#init#bootstrap()
  if s:loaded | return | endif | let s:loaded = 1

  call s:check_defined('g:airline_left_sep', get(g:, 'airline_powerline_fonts', 0)?"":">")
  call s:check_defined('g:airline_left_alt_sep', get(g:, 'airline_powerline_fonts', 0)?"":">")
  call s:check_defined('g:airline_right_sep', get(g:, 'airline_powerline_fonts', 0)?"":"<")
  call s:check_defined('g:airline_right_alt_sep', get(g:, 'airline_powerline_fonts', 0)?"":"<")
  call s:check_defined('g:airline_detect_modified', 1)
  call s:check_defined('g:airline_detect_paste', 1)
  call s:check_defined('g:airline_detect_iminsert', 0)
  call s:check_defined('g:airline_inactive_collapse', 1)
  call s:check_defined('g:airline_exclude_filenames', ['DebuggerWatch','DebuggerStack','DebuggerStatus'])
  call s:check_defined('g:airline_exclude_filetypes', [])
  call s:check_defined('g:airline_exclude_preview', 0)

  call s:check_defined('g:airline_mode_map', {})
  call extend(g:airline_mode_map, {
        \ '__' : '------',
        \ 'n'  : 'NORMAL',
        \ 'i'  : 'INSERT',
        \ 'R'  : 'REPLACE',
        \ 'v'  : 'VISUAL',
        \ 'V'  : 'V-LINE',
        \ 'c'  : 'COMMAND',
        \ '' : 'V-BLOCK',
        \ 's'  : 'SELECT',
        \ 'S'  : 'S-LINE',
        \ '' : 'S-BLOCK',
        \ }, 'keep')

  call s:check_defined('g:airline_theme_map', {})
  call extend(g:airline_theme_map, {
        \ 'Tomorrow.*': 'tomorrow',
        \ 'base16.*': 'base16',
        \ 'mo[l|n]okai': 'molokai',
        \ 'wombat.*': 'wombat',
        \ '.*solarized.*': 'solarized',
        \ }, 'keep')

  call s:check_defined('g:airline_symbols', {})
  call extend(g:airline_symbols, {
        \ 'paste': get(g:, 'airline_paste_symbol', 'PASTE'),
        \ 'readonly': get(g:, 'airline_readonly_symbol', get(g:, 'airline_powerline_fonts', 0) ? '' : 'RO'),
        \ 'whitespace': get(g:, 'airline_powerline_fonts', 0) ? '✹' : '!',
        \ 'linenr': get(g:, 'airline_linecolumn_prefix', get(g:, 'airline_powerline_fonts', 0) ? '' : ':' ),
        \ 'branch': get(g:, 'airline_branch_prefix', get(g:, 'airline_powerline_fonts', 0) ? '' : ''),
        \ }, 'keep')

  call airline#parts#define_function('mode', 'airline#parts#mode')
  call airline#parts#define_function('iminsert', 'airline#parts#iminsert')
  call airline#parts#define_function('paste', 'airline#parts#paste')
  call airline#parts#define_function('filetype', 'airline#parts#filetype')
  call airline#parts#define('readonly', {
        \ 'function': 'airline#parts#readonly',
        \ 'highlight': 'airline_file',
        \ })
  call airline#parts#define_raw('file', '%f%m')
  call airline#parts#define_raw('ffenc', '%{printf("%s%s",&fenc,strlen(&ff)>0?"[".&ff."]":"")}')
  call airline#parts#define_empty(['hunks', 'branch', 'tagbar', 'syntastic'])
endfunction

function! airline#init#sections()
  if !exists('g:airline_section_a')
    let g:airline_section_a = airline#section#create_left(['mode', 'paste', 'iminsert'])
  endif
  if !exists('g:airline_section_b')
    let g:airline_section_b = airline#section#create(['hunks', 'branch'])
  endif
  if !exists('g:airline_section_c')
    let g:airline_section_c = airline#section#create(['%<', 'file'])
  endif
  if !exists('g:airline_section_gutter')
    let g:airline_section_gutter = airline#section#create([' ', 'readonly', '%='])
  endif
  if !exists('g:airline_section_x')
    let g:airline_section_x = airline#section#create_right(['tagbar', 'filetype'])
  endif
  if !exists('g:airline_section_y')
    let g:airline_section_y = airline#section#create_right(['ffenc'])
  endif
  if !exists('g:airline_section_z')
    let g:airline_section_z = airline#section#create_right(['%3p%% %{g:airline_symbols.linenr} %3l:%3c '])
  endif
  if !exists('g:airline_section_warning')
    let g:airline_section_warning = airline#section#create(['syntastic', 'whitespace'])
  endif
endfunction

