" vim: ts=2 sts=2 sw=2 fdm=indent
let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running')
let s:sections = ['a','b','c','gutter','x','y','z']

let s:airline_highlight_map = {
      \ 'mode'           : 'Al2',
      \ 'mode_separator' : 'Al3',
      \ 'info'           : 'Al4',
      \ 'info_separator' : 'Al5',
      \ 'statusline'     : 'Al6',
      \ 'file'           : 'Al7',
      \ }

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
  call airline#extensions#load_theme()
endfunction

function! airline#highlight(modes)
  " draw the base mode, followed by any overrides
  let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
  for mode in mapped
    if exists('g:airline#themes#{g:airline_theme}#{mode}')
      for key in keys(g:airline#themes#{g:airline_theme}#{mode})
        let colors = g:airline#themes#{g:airline_theme}#{mode}[key]
        let suffix = a:modes[0] == 'inactive' ? '_inactive' : ''
        call airline#exec_highlight(s:airline_highlight_map[key].suffix, colors)
      endfor
    endif
  endfor
endfunction

function! s:is_excluded_window()
  for Fn in g:airline_exclude_funcrefs
    if Fn()
      return 1
    endif
  endfor
  return 0
endfunction

function! s:apply_window_overrides()
  unlet! w:airline_left_only
  for section in s:sections
    unlet! w:airline_section_{section}
  endfor
  for Fn in g:airline_window_override_funcrefs
    call Fn()
  endfor
endfunction

function! airline#update_externals()
  let g:airline_externals_bufferline = g:airline_enable_bufferline && exists('*bufferline#get_status_string')
        \ ? '%{bufferline#refresh_status()}'.bufferline#get_status_string() : "%f%m"
  let g:airline_externals_syntastic = g:airline_enable_syntastic && exists('*SyntasticStatuslineFlag')
        \ ? '%{SyntasticStatuslineFlag()}' : ''
  let g:airline_externals_branch = g:airline_enable_branch
        \ ? (exists('*fugitive#head') && strlen(fugitive#head()) > 0
          \ ? g:airline_branch_prefix.fugitive#head()
          \ : exists('*lawrencium#statusline') && strlen(lawrencium#statusline()) > 0
            \ ? g:airline_branch_prefix.lawrencium#statusline()
            \ : '')
        \ : ''
  let g:airline_externals_tagbar = g:airline_enable_tagbar && exists(':Tagbar')
        \ ? '%(%{tagbar#currenttag("%s","")} '.g:airline_right_alt_sep.'%)' : ''
endfunction

function! s:getwinvar(winnr, key, ...)
  " for 7.2 compatibility
  let winvals = getwinvar(a:winnr, '')
  return get(winvals, a:key, (a:0 ? a:1 : ''))
endfunction

function! s:get_section(winnr, key)
  return s:getwinvar(a:winnr, 'airline_section_'.a:key, g:airline_section_{a:key})
endfunction

function! s:get_statusline(winnr, active)
  let l:mode_color      = a:active ? "%#Al2#" : "%#Al2_inactive#"
  let l:mode_sep_color  = a:active ? "%#Al3#" : "%#Al3_inactive#"
  let l:info_color      = a:active ? "%#Al4#" : "%#Al4_inactive#"
  let l:info_sep_color  = a:active ? "%#Al5#" : "%#Al5_inactive#"
  let l:status_color    = a:active ? "%#Al6#" : "%#Al6_inactive#"
  let l:file_flag_color = a:active ? "%#Al7#" : "%#Al7_inactive#"

  let sl = '%{airline#update_highlight()}'
  if a:active || s:getwinvar(a:winnr, 'airline_left_only', 0)
    let sl.=l:mode_color.' '.s:get_section(a:winnr, 'a').' '
    let sl.='%{g:airline_detect_paste && &paste ? g:airline_paste_symbol." " : ""}'
    let sl.=l:mode_sep_color
    let sl.=a:active ? g:airline_left_sep : g:airline_left_alt_sep
    let sl.=l:info_color
    let sl.=' '.s:get_section(a:winnr, 'b').' '
    let sl.=l:info_sep_color
    let sl.=g:airline_left_sep
    let sl.=l:status_color.' %<'.s:get_section(a:winnr, 'c').' '
    let gutter = s:getwinvar(a:winnr, 'airline_section_gutter', get(g:, 'airline_section_gutter', ''))
    let sl.=gutter != ''
          \ ? gutter
          \ : '%#warningmsg#'.g:airline_externals_syntastic.l:file_flag_color."%{&ro ? g:airline_readonly_symbol : ''}".l:status_color
  else
    let sl.=l:status_color.' %f%m'
  endif
  if !s:getwinvar(a:winnr, 'airline_left_only', 0)
    let sl.='%='.g:airline_externals_tagbar
    let sl.=' '.s:get_section(a:winnr, 'x').' '
    let sl.=l:info_sep_color
    let sl.=a:active ? g:airline_right_sep : g:airline_right_alt_sep
    let sl.=l:info_color
    let sl.=' '.s:get_section(a:winnr, 'y').' '
    let sl.=l:mode_sep_color
    let sl.=a:active ? g:airline_right_sep : g:airline_right_alt_sep
    let sl.=l:mode_color
    let sl.=' '.s:get_section(a:winnr, 'z').' '
  endif
  return sl
endfunction

function! airline#update_statusline()
  let w:airline_active = 1
  if s:is_excluded_window()
    call setwinvar(winnr(), '&statusline', '')
    return
  endif

  call airline#update_externals()
  call s:apply_window_overrides()
  call setwinvar(winnr(), '&statusline', s:get_statusline(winnr(), 1))

  for nr in range(1, winnr('$'))
    if nr != winnr() && getwinvar(nr, 'airline_active')
      call setwinvar(nr, '&statusline', s:get_statusline(nr, 0))
      call setwinvar(nr, 'airline_active', 0)
    endif
  endfor
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
    if g:airline_detect_iminsert && &iminsert
      if get(g:, 'airline_powerline_fonts', 0)
        let g:airline_current_mode_text .= ' '.g:airline_left_alt_sep
      endif
      let g:airline_current_mode_text .= ' '.toupper(get(b:, 'keymap_name', 'lang'))
    endif
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
