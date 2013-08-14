" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

if &cp || v:version < 702 || (exists('g:loaded_airline') && g:loaded_airline)
  finish
endif
let g:loaded_airline = 1
function! s:check_defined(variable, default)
  if !exists(a:variable)
    let {a:variable} = a:default
  endif
endfunction
call s:check_defined('g:airline_left_sep', exists('g:airline_powerline_fonts')?"":">")
call s:check_defined('g:airline_left_alt_sep', exists('g:airline_powerline_fonts')?"":">")
call s:check_defined('g:airline_right_sep', exists('g:airline_powerline_fonts')?"":"<")
call s:check_defined('g:airline_right_alt_sep', exists('g:airline_powerline_fonts')?"":"<")
call s:check_defined('g:airline_enable_bufferline', 1)
call s:check_defined('g:airline_enable_branch', 1)
call s:check_defined('g:airline_enable_syntastic', 1)
call s:check_defined('g:airline_enable_tagbar', 1)
call s:check_defined('g:airline_enable_csv', 1)
call s:check_defined('g:airline_detect_iminsert', 0)
call s:check_defined('g:airline_detect_modified', 1)
call s:check_defined('g:airline_detect_paste', 1)
call s:check_defined('g:airline_detect_whitespace', 1)
call s:check_defined('g:airline_whitespace_symbol', '✹')
call s:check_defined('g:airline_branch_empty_message', '')
call s:check_defined('g:airline_branch_prefix', exists('g:airline_powerline_fonts')?' ':'')
call s:check_defined('g:airline_readonly_symbol', exists('g:airline_powerline_fonts')?'':'RO')
call s:check_defined('g:airline_linecolumn_prefix', exists('g:airline_powerline_fonts')?' ':':')
call s:check_defined('g:airline_paste_symbol', (exists('g:airline_powerline_fonts') ? ' ' : '').'PASTE')
call s:check_defined('g:airline_theme', 'dark')
call s:check_defined('g:airline_inactive_collapse', 1)
call s:check_defined('g:airline_exclude_filenames', ['DebuggerWatch','DebuggerStack','DebuggerStatus'])
call s:check_defined('g:airline_exclude_filetypes', [])
call s:check_defined('g:airline_exclude_preview', 0)
call s:check_defined('g:airline_statusline_funcrefs', [])
call s:check_defined('g:airline_exclude_funcrefs', [])

call s:check_defined('g:airline_mode_map', {
      \ '__' : '------',
      \ 'n'  : 'NORMAL',
      \ 'i'  : 'INSERT',
      \ 'R'  : 'REPLACE',
      \ 'v'  : 'VISUAL',
      \ 'V'  : 'V-LINE',
      \ 'c'  : 'CMD   ',
      \ '' : 'V-BLOCK',
      \ 's'  : 'SELECT',
      \ 'S'  : 'S-LINE',
      \ '' : 'S-BLOCK',
      \ })

call s:check_defined('g:airline_section_a', '%{get(w:, "airline_current_mode", "")}')
call s:check_defined('g:airline_section_b', '%{get(w:, "airline_current_branch", "")}')
call s:check_defined('g:airline_section_c', '%f%m')
call s:check_defined('g:airline_section_gutter', '%=')
call s:check_defined('g:airline_section_x', "%{strlen(&filetype)>0?&filetype:''}")
call s:check_defined('g:airline_section_y', "%{strlen(&fenc)>0?&fenc:''}%{strlen(&ff)>0?'['.&ff.']':''}")
call s:check_defined('g:airline_section_z', '%3p%% '.g:airline_linecolumn_prefix.'%3l:%3c')
call s:check_defined('g:airline_section_warning', '')

let s:airline_initialized = 0
function! s:on_window_changed()
  if !s:airline_initialized
    call airline#extensions#load()
    call airline#load_theme(g:airline_theme)
    let s:airline_initialized = 1
  endif
  call airline#update_statusline()
endfunction

function! s:get_airline_themes(a, l, p)
  let files = split(globpath(&rtp, 'autoload/airline/themes/'.a:a.'*'), "\n")
  return map(files, 'fnamemodify(v:val, ":t:r")')
endfunction
function! s:airline_theme(...)
  if a:0
    call airline#load_theme(a:1)
  else
    echo g:airline_theme
  endif
endfunction
command! -nargs=? -complete=customlist,<sid>get_airline_themes AirlineTheme call <sid>airline_theme(<f-args>)
command! AirlineToggleWhitespace call airline#extensions#whitespace#toggle()

augroup airline
  autocmd!
  autocmd ColorScheme * call airline#reload_highlight()
  autocmd WinEnter,BufWinEnter,FileType,BufUnload,ShellCmdPost *
        \ call <sid>on_window_changed()
augroup END
