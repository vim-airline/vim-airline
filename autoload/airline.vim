" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running')
let s:sections = ['a','b','c','gutter','x','y','z','warning']

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
        \ len(colors) > 4 && colors[4] != '' ? 'gui='.colors[4] : '',
        \ len(colors) > 4 && colors[4] != '' ? 'cterm='.colors[4] : '',
        \ len(colors) > 4 && colors[4] != '' ? 'term='.colors[4] : '')
endfunction

function! airline#reload_highlight()
  call airline#highlight(['inactive'])
  call airline#highlight(['normal'])
  call airline#extensions#load_theme()
endfunction

function! airline#load_theme(name)
  let g:airline_theme = a:name
  let inactive_colors = g:airline#themes#{g:airline_theme}#inactive "also lazy loads the theme
  let w:airline_lastmode = ''
  call airline#reload_highlight()
  call airline#update_highlight()
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
  call airline#themes#exec_highlight_separator('Al2', 'warningmsg')
endfunction

" for 7.2 compatibility
function! s:getwinvar(winnr, key, ...)
  let winvals = getwinvar(a:winnr, '')
  return get(winvals, a:key, (a:0 ? a:1 : ''))
endfunction

function! s:get_section(winnr, key, ...)
  let text = s:getwinvar(a:winnr, 'airline_section_'.a:key, g:airline_section_{a:key})
  let [prefix, suffix] = [get(a:000, 0, '%( '), get(a:000, 1, ' %)')]
  return empty(text) ? '' : prefix.text.suffix
endfunction

function! airline#get_statusline(winnr, active)
  let l:mode_color      = a:active ? "%#Al2#" : "%#Al2_inactive#"
  let l:mode_sep_color  = a:active ? "%#Al3#" : "%#Al3_inactive#"
  let l:info_color      = a:active ? "%#Al4#" : "%#Al4_inactive#"
  let l:info_sep_color  = a:active ? "%#Al5#" : "%#Al5_inactive#"
  let l:status_color    = a:active ? "%#Al6#" : "%#Al6_inactive#"
  let l:file_flag_color = a:active ? "%#Al7#" : "%#Al7_inactive#"

  let sl = '%{airline#update_highlight()}'
  if s:getwinvar(a:winnr, 'airline_render_left', a:active || (!a:active && !g:airline_inactive_collapse))
    let sl.=l:mode_color.s:get_section(a:winnr, 'a')
    let sl.='%{g:airline_detect_paste && &paste ? g:airline_paste_symbol." " : ""}'
    let sl.=l:mode_sep_color
    let sl.=a:active ? g:airline_left_sep : g:airline_left_alt_sep
    let sl.=l:info_color
    let sl.=s:get_section(a:winnr, 'b')
    let sl.=l:info_sep_color
    let sl.=g:airline_left_sep
    let sl.=l:status_color.'%<'.s:get_section(a:winnr, 'c')
    let sl.=' '.l:file_flag_color."%(%{&ro ? g:airline_readonly_symbol : ''}%)"
  else
    let sl.=l:status_color.' %f%m'
  endif
  let sl.=l:status_color.s:get_section(a:winnr, 'gutter', '', '').l:status_color
  if s:getwinvar(a:winnr, 'airline_render_right', 1)
    let sl.=s:get_section(a:winnr, 'x')
    let sl.=l:info_sep_color
    let sl.=a:active ? g:airline_right_sep : g:airline_right_alt_sep
    let sl.=l:info_color
    let sl.=s:get_section(a:winnr, 'y')
    let sl.=l:mode_sep_color
    let sl.=a:active ? g:airline_right_sep : g:airline_right_alt_sep
    let sl.=l:mode_color
    let sl.=s:get_section(a:winnr, 'z')

    if a:active
      let sl.='%(%#Al2_to_warningmsg#'.g:airline_right_sep
      let sl.='%#warningmsg#'.s:get_section(a:winnr, 'warning', '', '').'%)'
    endif
  endif
  return sl
endfunction

function! airline#exec_funcrefs(list, break_early)
  " for 7.2; we cannot iterate list, hence why we use range()
  " for 7.3-[97, 328]; we cannot reuse the variable, hence the {}
  for i in range(0, len(a:list) - 1)
    let Fn{i} = a:list[i]
    if a:break_early
      if Fn{i}()
        return 1
      endif
    else
      call Fn{i}()
    endif
  endfor
  return 0
endfunction

function! airline#update_statusline()
  if airline#exec_funcrefs(g:airline_exclude_funcrefs, 1)
    call setwinvar(winnr(), '&statusline', '')
    return
  endif

  for nr in filter(range(1, winnr('$')), 'v:val != winnr()')
    call setwinvar(nr, 'airline_active', 0)
    call setwinvar(nr, '&statusline', airline#get_statusline(nr, 0))
  endfor

  let w:airline_active = 1

  unlet! w:airline_render_left
  unlet! w:airline_render_right
  for section in s:sections
    unlet! w:airline_section_{section}
  endfor
  call airline#exec_funcrefs(g:airline_statusline_funcrefs, 0)

  call setwinvar(winnr(), '&statusline', airline#get_statusline(winnr(), 1))
endfunction

function! airline#update_highlight()
  if get(w:, 'airline_active', 1)
    let l:m = mode()
    if l:m ==# "i"
      let l:mode = ['insert']
    elseif l:m ==# "R"
      let l:mode = ['replace']
    elseif l:m =~# '\v(v|V||s|S|)'
      let l:mode = ['visual']
    else
      let l:mode = ['normal']
    endif
    let w:airline_current_mode = get(g:airline_mode_map, l:m, l:m)
  else
    let l:mode = ['inactive']
    let w:airline_current_mode = get(g:airline_mode_map, '__')
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
