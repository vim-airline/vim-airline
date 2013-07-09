" vim: ts=2 sts=2 sw=2 fdm=indent
let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running')
let s:inactive_colors = g:airline#themes#{g:airline_theme}#inactive "also lazy loads the theme

let s:airline_highlight_map = {
      \ 'mode'           : 'Al2',
      \ 'mode_separator' : 'Al3',
      \ 'info'           : 'Al4',
      \ 'info_separator' : 'Al5',
      \ 'statusline'     : 'Al6',
      \ 'file'           : 'Al7',
      \ }
let s:airline_highlight_groups = keys(s:airline_highlight_map)

function! airline#exec_highlight(group, colors)
  exec printf('hi %s %s %s %s %s %s %s',
        \ a:group,
        \ a:colors[0] != '' ? 'guifg='.a:colors[0] : '',
        \ a:colors[1] != '' ? 'guibg='.a:colors[1] : '',
        \ a:colors[2] != '' ? 'ctermfg='.a:colors[2] : '',
        \ a:colors[3] != '' ? 'ctermbg='.a:colors[3] : '',
        \ a:colors[4] != '' ? 'gui='.a:colors[4] : '',
        \ a:colors[4] != '' ? 'term='.a:colors[4] : '')
endfunction
call airline#exec_highlight('airline_inactive', s:inactive_colors.mode)

function! airline#highlight(modes)
  " always draw the base mode, and then override any/all of the colors with _override
  let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
  for mode in mapped
    for key in s:airline_highlight_groups
      if exists('g:airline#themes#{g:airline_theme}#{mode}[key]')
        let colors = g:airline#themes#{g:airline_theme}#{mode}[key]
        if s:is_win32term
          let colors = map(colors, 'v:val != "" && v:val > 128 ? v:val - 128 : v:val')
        endif
        call airline#exec_highlight(s:airline_highlight_map[key], colors)
      endif
    endfor
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

function! s:apply_window_overrides()
  if &buftype == 'quickfix'
    let w:airline_section_a = 'Quickfix'
    let w:airline_section_b = ''
    let w:airline_section_c = ''
    let w:airline_section_x = ''
  endif

  if &previewwindow
    let w:airline_section_a = 'Preview'
    let w:airline_section_b = ''
    let w:airline_section_c = bufname(winbufnr(winnr()))
  endif

  call airline#extensions#apply_window_overrides()
endfunction

function! airline#update_externals()
  let g:airline_externals_bufferline = g:airline_enable_bufferline && exists('g:bufferline_loaded') ? '%{bufferline#generate_string()}' : "%f%m"
  let g:airline_externals_syntastic = g:airline_enable_syntastic && exists('g:loaded_syntastic_plugin') ? '%{SyntasticStatuslineFlag()}' : ''
  let g:airline_externals_fugitive = g:airline_enable_fugitive && exists('g:loaded_fugitive') && strlen(fugitive#head()) > 0
        \ ? g:airline_fugitive_prefix.fugitive#head() : ''
endfunction

function! s:get_section(key)
  return exists('w:airline_section_{a:key}') ? w:airline_section_{a:key} : g:airline_section_{a:key}
endfunction

function! airline#update_statusline(active)
  if s:is_excluded_window()
    call setwinvar(winnr(), '&statusline', '')
    return
  endif

  call airline#update_externals()
  call s:apply_window_overrides()

  let l:mode_color      = a:active ? "%#Al2#" : "%#airline_inactive#"
  let l:mode_sep_color  = a:active ? "%#Al3#" : "%#airline_inactive#"
  let l:info_color      = a:active ? "%#Al4#" : "%#airline_inactive#"
  let l:info_sep_color  = a:active ? "%#Al5#" : "%#airline_inactive#"
  let l:status_color    = a:active ? "%#Al6#" : "%#airline_inactive#"
  let l:file_flag_color = a:active ? "%#Al7#" : "%#airline_inactive#"

  let sl = l:mode_color
  if a:active
    let sl.='%{airline#update_highlight()} '.s:get_section('a').' %{&paste ? g:airline_paste_symbol." " : ""}'
    let sl.=l:mode_sep_color
    let sl.=a:active ? g:airline_left_sep : g:airline_left_alt_sep
    let sl.=l:info_color
    let sl.=' '.s:get_section('b').' '
    let sl.=l:info_sep_color
    let sl.=g:airline_left_sep
    let sl.=l:status_color.' '.s:get_section('c').' '
    let sl.=exists('w:airline_section_gutter')
          \ ? s:get_section('gutter')
          \ : '%#warningmsg#'.g:airline_externals_syntastic.l:file_flag_color."%{&ro ? g:airline_readonly_symbol : ''}".l:status_color
  else
    let sl.=' %f'
  endif
  if !exists('w:airline_left_only')
    let sl.='%<%= '.s:get_section('x').' '
    let sl.=l:info_sep_color
    let sl.=a:active ? g:airline_right_sep : g:airline_right_alt_sep
    let sl.=l:info_color
    let sl.=' '.s:get_section('y').' '
    let sl.=l:mode_sep_color
    let sl.=a:active ? g:airline_right_sep : g:airline_right_alt_sep
    let sl.=l:mode_color
    let sl.=' '.s:get_section('z').' '
  endif
  call setwinvar(winnr(), '&statusline', sl)
endfunction

let s:lastmode = ''
let g:airline_current_mode_text = ''
function! airline#update_highlight()
  let l:m = mode()
  if l:m ==# "i" || l:m ==# "R"
    let l:mode = ['insert']
  elseif l:m ==? "v" || l:m ==# ""
    let l:mode = ['visual']
  else
    let l:mode = ['normal']
  endif

  if &modified
    call add(l:mode, 'modified')
  endif
  if &paste
    call add(l:mode, 'paste')
  endif
  if l:m ==# "R"
    call add(l:mode, 'replace')
  endif
  if &previewwindow
    call add(l:mode, 'preview')
  endif

  let mode_string = join(l:mode)
  if s:lastmode != mode_string
    call airline#highlight(l:mode)
    let s:lastmode = mode_string
  endif

  let g:airline_current_mode_text = get(g:airline_mode_map, l:m, l:m)
  return ''
endfunction
