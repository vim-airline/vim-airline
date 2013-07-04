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
call s:check_defined('g:airline_right_sep', exists('g:airline_powerline_fonts')?"":"<")
call s:check_defined('g:airline_enable_bufferline', 1)
call s:check_defined('g:airline_enable_fugitive', 1)
call s:check_defined('g:airline_enable_syntastic', 1)
call s:check_defined('g:airline_fugitive_prefix', exists('g:airline_powerline_fonts')?' ':'')
call s:check_defined('g:airline_readonly_symbol', exists('g:airline_powerline_fonts')?'':'RO')
call s:check_defined('g:airline_linecolumn_prefix', exists('g:airline_powerline_fonts')?' ':':')
call s:check_defined('g:airline_theme', 'dark')
call s:check_defined('g:airline_modified_detection', 1)
call s:check_defined('g:airline_exclude_filenames', ['DebuggerWatch','DebuggerStack','DebuggerStatus'])
call s:check_defined('g:airline_exclude_filetypes', ['qf','netrw','diff','undotree','gundo','nerdtree','tagbar'])

let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running')
let s:load_the_theme = g:airline#themes#{g:airline_theme}#normal

call s:check_defined('g:airline_mode_map', {
      \ 'n'  : 'NORMAL',
      \ 'i'  : 'INSERT',
      \ 'R'  : 'RPLACE',
      \ 'v'  : 'VISUAL',
      \ 'V'  : 'V-LINE',
      \ 'c'  : 'CMD   ',
      \ '' : 'V-BLCK',
      \ })
let s:airline_highlight_map = {
      \ 'mode'           : 'Al2',
      \ 'mode_separator' : 'Al3',
      \ 'info'           : 'Al4',
      \ 'info_separator' : 'Al5',
      \ 'statusline'     : 'Al6',
      \ 'file'           : 'Al7',
      \ 'inactive'       : 'Al9',
      \ }
let s:airline_highlight_groups = keys(s:airline_highlight_map)

function! s:highlight(mode)
  for key in s:airline_highlight_groups
    if exists('g:airline#themes#{g:airline_theme}#{a:mode}[key]')
      let colors = g:airline#themes#{g:airline_theme}#{a:mode}[key]
      if s:is_win32term
        let colors = map(colors, 'v:val != "" && v:val > 128 ? v:val - 128 : v:val')
      endif
      let cmd = printf('hi %s %s %s %s %s %s %s',
            \ s:airline_highlight_map[key],
            \ colors[0] != '' ? 'guifg='.colors[0] : '',
            \ colors[1] != '' ? 'guibg='.colors[1] : '',
            \ colors[2] != '' ? 'ctermfg='.colors[2] : '',
            \ colors[3] != '' ? 'ctermbg='.colors[3] : '',
            \ colors[4] != '' ? 'gui='.colors[4] : '',
            \ colors[4] != '' ? 'term='.colors[4] : '')
      exec cmd
    endif
  endfor
endfunction

function! s:is_excluded_window()
  for matchft in g:airline_exclude_filetypes
    if matchft ==# &ft
      return 1
    endif
  endfor
  for matchw in g:airline_exclude_filenames
    if matchstr(expand('%'), matchw) ==# matchw
      return 1
    endif
  endfor
  return 0
endfunction

function! s:update_externals()
  let g:airline_externals_bufferline = g:airline_enable_bufferline && exists('g:bufferline_loaded') ? '%{bufferline#generate_string()}' : "%f%m"
  let g:airline_externals_syntastic = g:airline_enable_syntastic && exists('g:loaded_syntastic_plugin') ? '%{SyntasticStatuslineFlag()}' : ''
  let g:airline_externals_fugitive = g:airline_enable_fugitive && exists('g:loaded_fugitive') && strlen(fugitive#head()) > 0
        \ ? g:airline_fugitive_prefix.fugitive#head() : ''
endfunction
call s:update_externals()

call s:check_defined('g:airline_section_a', '%{g:airline_current_mode_text}')
call s:check_defined('g:airline_section_b', '%{g:airline_externals_fugitive}')
call s:check_defined('g:airline_section_c', g:airline_externals_bufferline)
call s:check_defined('g:airline_section_x', "%{strlen(&filetype)>0?&filetype:''}")
call s:check_defined('g:airline_section_y', "%{strlen(&fenc)>0?&fenc:''}%{strlen(&ff)>0?'['.&ff.']':''}")
call s:check_defined('g:airline_section_z', '%3p%% '.g:airline_linecolumn_prefix.'%3l:%3c')

function! s:update_statusline(active)
  if s:is_excluded_window()
    return
  endif

  call s:update_externals()
  let l:mode_color      = a:active ? "%#Al2#" : "%#Al9#"
  let l:mode_sep_color  = a:active ? "%#Al3#" : "%#Al9#"
  let l:info_color      = a:active ? "%#Al4#" : "%#Al9#"
  let l:info_sep_color  = a:active ? "%#Al5#" : "%#Al9#"
  let l:status_color    = a:active ? "%#Al6#" : "%#Al9#"
  let l:file_flag_color = a:active ? "%#Al7#" : "%#Al9#"

  let sl = l:mode_color
  let sl.= a:active
        \ ? '%{AirlineUpdateHighlight()} '.g:airline_section_a.' '.l:mode_sep_color
        \ : '        %#Al9#'
  let sl.='%{g:airline_left_sep}'.l:info_color
  let sl.=' '.g:airline_section_b.' '
  let sl.=l:info_sep_color.g:airline_left_sep
  if a:active
    let sl.=l:status_color.' '.g:airline_section_c.' '
  else
    let sl.=" ".bufname(winbufnr(winnr()))
  endif
  let sl.="%#warningmsg#"
  let sl.=g:airline_externals_syntastic
  let sl.=l:status_color."%<%=".l:file_flag_color."%{&ro ? g:airline_readonly_symbol : ''}"
  let sl.="%q%{&previewwindow?'[preview]':''}"
  let sl.=l:status_color
  let sl.=' '.g:airline_section_x.' '
  let sl.=l:info_sep_color.g:airline_right_sep.l:info_color
  let sl.=' '.g:airline_section_y.' '
  let sl.=l:mode_sep_color.g:airline_right_sep.l:mode_color
  let sl.=' '.g:airline_section_z.' '
  call setwinvar(winnr(), '&statusline', sl)
endfunction

let s:lastmode = ''
let g:airline_current_mode_text = ''
function! AirlineUpdateHighlight()
  let l:m = mode()
  let l:mode = 'normal'
  if l:m ==# "i" || l:m ==# "R"
    let l:mode = 'insert'
  elseif l:m ==? "v" || l:m ==# ""
    let l:mode = 'visual'
  endif

  if g:airline_modified_detection && &modified
    let l:mode .= '_modified'
  endif

  if s:lastmode != l:mode
    call <sid>highlight(l:mode)
    let s:lastmode = l:mode
  endif

  let g:airline_current_mode_text = get(g:airline_mode_map, l:m, l:m)
  return ''
endfunction

augroup airline
  au!
  autocmd VimEnter,ColorScheme * call <sid>highlight('normal')
  autocmd WinLeave * call <sid>update_statusline(0)
  autocmd VimEnter,WinEnter,BufWinEnter * call <sid>update_statusline(1)
augroup END
