" vim: ts=2 sts=2 sw=2 fdm=indent
let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running')

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
  let colors = a:colors
  if s:is_win32term
    let colors = map(a:colors, 'v:val != "" && v:val > 128 ? v:val - 128 : v:val')
  endif
  exec printf('hi %s %s %s %s %s %s %s %s',
        \ a:group,
        \ colors[0] != '' ? 'guifg='.colors[0] : '',
        \ colors[1] != '' ? 'guibg='.colors[1] : '',
        \ colors[2] != '' ? 'ctermfg='.colors[2] : '',
        \ colors[3] != '' ? 'ctermbg='.colors[3] : '',
        \ colors[4] != '' ? 'gui='.colors[4] : '',
        \ colors[4] != '' ? 'cterm='.colors[4] : '',
        \ colors[4] != '' ? 'term='.colors[4] : '')
endfunction

function! airline#load_theme(name)
  let g:airline_theme = a:name
  let inactive_colors = g:airline#themes#{g:airline_theme}#inactive "also lazy loads the theme
  let w:airline_lastmode = ''
  call airline#highlight(['inactive'])
  call airline#update_highlight()
endfunction

function! airline#highlight(modes)
  " draw the base mode, followed by any overrides
  let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
  for mode in mapped
    for key in s:airline_highlight_groups
      if exists('g:airline#themes#{g:airline_theme}#{mode}[key]')
        let colors = g:airline#themes#{g:airline_theme}#{mode}[key]
        let suffix = a:modes[0] == 'inactive' ? '_inactive' : ''
        call airline#exec_highlight(s:airline_highlight_map[key].suffix, colors)
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
  if g:airline_exclude_preview && &previewwindow
    return 1
  endif
  return 0
endfunction

function! s:apply_window_overrides()
  call airline#extensions#clear_window_overrides()

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

  for FuncRef in g:airline_window_override_funcrefs
    call FuncRef()
  endfor
endfunction

function! airline#update_externals()
  let g:airline_externals_bufferline = g:airline_enable_bufferline && exists('*bufferline#get_status_string')
        \ ? '%{bufferline#refresh_status()}'.bufferline#get_status_string()
        \ : "%f%m"
  let g:airline_externals_syntastic = g:airline_enable_syntastic && exists('*SyntasticStatuslineFlag') ? '%{SyntasticStatuslineFlag()}' : ''
  let g:airline_externals_fugitive = g:airline_enable_fugitive ? (exists('*fugitive#head') && strlen(fugitive#head()) > 0
        \ ? g:airline_fugitive_prefix.fugitive#head() : exists('*lawrencium#statusline') && strlen(lawrencium#statusline()) > 0
        \ ? g:airline_fugitive_prefix.lawrencium#statusline() : '') : ''
endfunction

function! s:get_section(key)
  return exists('w:airline_section_{a:key}') ? w:airline_section_{a:key} : g:airline_section_{a:key}
endfunction

function! airline#update_statusline(active)
  let w:airline_active = a:active
  if s:is_excluded_window()
    call setwinvar(winnr(), '&statusline', '')
    return
  endif

  call airline#update_externals()
  call s:apply_window_overrides()

  let l:mode_color      = a:active ? "%#Al2#" : "%#Al2_inactive#"
  let l:mode_sep_color  = a:active ? "%#Al3#" : "%#Al3_inactive#"
  let l:info_color      = a:active ? "%#Al4#" : "%#Al4_inactive#"
  let l:info_sep_color  = a:active ? "%#Al5#" : "%#Al5_inactive#"
  let l:status_color    = a:active ? "%#Al6#" : "%#Al6_inactive#"
  let l:file_flag_color = a:active ? "%#Al7#" : "%#Al7_inactive#"

  let sl = '%{airline#update_highlight()}'
  if a:active
    let sl.=l:mode_color.' '.s:get_section('a').' '
    let sl.=l:mode_sep_color
    let sl.=a:active ? g:airline_left_sep : g:airline_left_alt_sep
    let sl.=l:info_color
    let sl.=' '.s:get_section('b').' '
    let sl.=l:info_sep_color
    let sl.=g:airline_left_sep
    let sl.=l:status_color.' %<'.s:get_section('c').' '
    let gutter = get(w:, 'airline_section_gutter', get(g:, 'airline_section_gutter', ''))
    let sl.=gutter != ''
          \ ? gutter
          \ : '%#warningmsg#'.g:airline_externals_syntastic.l:file_flag_color."%{&ro ? g:airline_readonly_symbol : ''}".l:status_color
  else
    let sl.=l:status_color.' %f%m'
  endif
  if !exists('w:airline_left_only')
    let sl.='%= '.s:get_section('x').' '
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

let g:airline_current_mode_text = ''
function! airline#update_highlight()
  if get(w:, 'airline_active', 1)
    let l:m = mode()
    if l:m ==# "i"
      let l:mode = ['insert']
    elseif l:m ==# "R"
      let l:mode = ['replace']
    elseif l:m ==? "v" || l:m ==# ""
      let l:mode = ['visual']
    else
      let l:mode = ['normal']
    endif
    let g:airline_current_mode_text = get(g:airline_mode_map, l:m, l:m)
  else
    let l:mode = ['inactive']
  endif

  if g:airline_detect_modified && &modified | call add(l:mode, 'modified') | endif
  if g:airline_detect_paste    && &paste    | call add(l:mode, 'paste')    | endif

  let mode_string = join(l:mode)
  if get(w:, 'airline_lastmode', '') != mode_string
    call airline#highlight(l:mode)
    let w:airline_lastmode = mode_string
  endif
  return ''
endfunction
