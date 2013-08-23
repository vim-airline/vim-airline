" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

if &cp || v:version < 702 || (exists('g:loaded_airline') && g:loaded_airline)
  finish
endif
let g:loaded_airline = 1

function! s:check_defined(variable, default)
  if !exists(a:variable)
    let {a:variable} = a:default
  endif
endfunction

call s:check_defined('g:airline_left_sep', get(g:, 'airline_powerline_fonts', 0)?"":">")
call s:check_defined('g:airline_left_alt_sep', get(g:, 'airline_powerline_fonts', 0)?"":">")
call s:check_defined('g:airline_right_sep', get(g:, 'airline_powerline_fonts', 0)?"":"<")
call s:check_defined('g:airline_right_alt_sep', get(g:, 'airline_powerline_fonts', 0)?"":"<")
call s:check_defined('g:airline_detect_iminsert', 0)
call s:check_defined('g:airline_detect_modified', 1)
call s:check_defined('g:airline_detect_paste', 1)
call s:check_defined('g:airline_linecolumn_prefix', get(g:, 'airline_powerline_fonts', 0)?' ':':')
call s:check_defined('g:airline_inactive_collapse', 1)
call s:check_defined('g:airline_exclude_filenames', ['DebuggerWatch','DebuggerStack','DebuggerStatus'])
call s:check_defined('g:airline_exclude_filetypes', [])
call s:check_defined('g:airline_exclude_preview', 0)

call s:check_defined('g:airline_mode_map', {
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
      \ })

call s:check_defined('g:airline_theme_map', {
      \ 'Tomorrow.*': 'tomorrow',
      \ 'mo[l|n]okai': 'molokai',
      \ 'wombat.*': 'wombat',
      \ '.*solarized.*': 'solarized',
      \ })

call s:check_defined('g:airline_section_a', '%{get(w:, "airline_current_mode", "")}')
call s:check_defined('g:airline_section_b', '')
call s:check_defined('g:airline_section_c', '%f%m')
call s:check_defined('g:airline_section_gutter', '%=')
call s:check_defined('g:airline_section_x', "%{strlen(&filetype)>0?&filetype:''}")
call s:check_defined('g:airline_section_y', "%{strlen(&fenc)>0?&fenc:''}%{strlen(&ff)>0?'['.&ff.']':''}")
call s:check_defined('g:airline_section_z', '%3p%% '.g:airline_linecolumn_prefix.'%3l:%3c')
call s:check_defined('g:airline_section_warning', '__')

let s:airline_initialized = 0
let s:airline_theme_defined = 0
function! s:init()
  if !s:airline_initialized
    let s:airline_initialized = 1

    call airline#extensions#load()

    let s:airline_theme_defined = exists('g:airline_theme')
    if s:airline_theme_defined || !airline#switch_matching_theme()
      let g:airline_theme = get(g:, 'airline_theme', 'dark')
      call airline#switch_theme(g:airline_theme)
    endif
  endif
endfunction

function! s:on_window_changed()
  call <sid>init()
  call airline#update_statusline()
endfunction

function! s:on_colorscheme_changed()
  call <sid>init()
  if !s:airline_theme_defined
    if airline#switch_matching_theme()
      return
    endif
  endif

  " couldn't find a match, or theme was defined, just refresh
  call airline#load_theme()
endfunction

function airline#cmdwinenter(...)
  call airline#extensions#apply_left_override('Command Line', '')
endfunction

function! s:airline_toggle()
  if exists("#airline")
    augroup airline
      au!
    augroup END
    augroup! airline
    if exists("s:stl")
      let &stl = s:stl
    endif
  else
    let s:stl = &stl
    augroup airline
      autocmd!

      autocmd CmdwinEnter *
            \ call airline#add_statusline_func('airline#cmdwinenter')
            \ | call <sid>on_window_changed()
      autocmd CmdwinLeave * call airline#remove_statusline_func('airline#cmdwinenter')

      autocmd ColorScheme * call <sid>on_colorscheme_changed()
      autocmd WinEnter,BufWinEnter,FileType,BufUnload,ShellCmdPost *
            \ call <sid>on_window_changed()
    augroup END
    if s:airline_initialized
      call <sid>on_window_changed()
    endif
  endif
endfunction

function! s:get_airline_themes(a, l, p)
  let files = split(globpath(&rtp, 'autoload/airline/themes/'.a:a.'*'), "\n")
  return map(files, 'fnamemodify(v:val, ":t:r")')
endfunction
function! s:airline_theme(...)
  if a:0
    call airline#switch_theme(a:1)
  else
    echo g:airline_theme
  endif
endfunction
command! -nargs=? -complete=customlist,<sid>get_airline_themes AirlineTheme call <sid>airline_theme(<f-args>)
command! AirlineToggleWhitespace call airline#extensions#whitespace#toggle()
command! AirlineToggle call <sid>airline_toggle()

call <sid>airline_toggle()

