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
call s:check_defined('g:airline_enable_fugitive', 1)
call s:check_defined('g:airline_enable_syntastic', 1)
call s:check_defined('g:airline_detect_modified', 1)
call s:check_defined('g:airline_detect_paste', 1)
call s:check_defined('g:airline_fugitive_prefix', exists('g:airline_powerline_fonts')?' ':'')
call s:check_defined('g:airline_readonly_symbol', exists('g:airline_powerline_fonts')?'':'RO')
call s:check_defined('g:airline_linecolumn_prefix', exists('g:airline_powerline_fonts')?' ':':')
call s:check_defined('g:airline_paste_symbol', (exists('g:airline_powerline_fonts') ? ' ' : '').'PASTE')
call s:check_defined('g:airline_theme', 'dark')
call s:check_defined('g:airline_exclude_filenames', ['DebuggerWatch','DebuggerStack','DebuggerStatus'])
call s:check_defined('g:airline_exclude_filetypes', [])
call s:check_defined('g:airline_exclude_preview', 0)
call s:check_defined('g:airline_window_override_funcrefs', [])

call s:check_defined('g:airline_mode_map', {
      \ 'n'  : 'NORMAL',
      \ 'i'  : 'INSERT',
      \ 'R'  : 'RPLACE',
      \ 'v'  : 'VISUAL',
      \ 'V'  : 'V-LINE',
      \ 'c'  : 'CMD   ',
      \ '' : 'V-BLCK',
      \ })

let s:airline_initialized = 0
function! s:init()
  if !s:airline_initialized
    call airline#extensions#load()
    call airline#update_externals()
    call airline#load_theme(g:airline_theme)
    call s:check_defined('g:airline_section_a', '%{g:airline_current_mode_text} %{&paste ? g:airline_paste_symbol." " : ""}')
    call s:check_defined('g:airline_section_b', '%{g:airline_externals_fugitive}')
    call s:check_defined('g:airline_section_c', g:airline_externals_bufferline)
    call s:check_defined('g:airline_section_gutter', '')
    call s:check_defined('g:airline_section_x', "%{strlen(&filetype)>0?&filetype:''}")
    call s:check_defined('g:airline_section_y', "%{strlen(&fenc)>0?&fenc:''}%{strlen(&ff)>0?'['.&ff.']':''}")
    call s:check_defined('g:airline_section_z', '%3p%% '.g:airline_linecolumn_prefix.'%3l:%3c')
    let s:airline_initialized = 1
  endif
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

augroup airline
  au!
  autocmd ColorScheme * call airline#highlight(['normal'])
  autocmd WinLeave * call airline#update_statusline(0)
  autocmd WinEnter,BufWinEnter,FileType * call <sid>init() | call airline#update_statusline(1)
  autocmd ShellCmdPost * call airline#update_externals()
augroup END
