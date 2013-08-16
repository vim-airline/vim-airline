" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running')
let s:sections = ['a','b','c','gutter','x','y','z','warning']

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
  call airline#update_statusline()
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
        call airline#exec_highlight(key.suffix, colors)
      endfor
    endif
  endfor
  for sep in w:airline_current_info.separator_groups
    call airline#themes#exec_highlight_separator(sep[0], sep[1])
  endfor
endfunction

function! s:get_section(winnr, key, ...)
  let text = airline#util#getwinvar(a:winnr, 'airline_section_'.a:key, g:airline_section_{a:key})
  let [prefix, suffix] = [get(a:000, 0, '%( '), get(a:000, 1, ' %)')]
  return empty(text) ? '' : prefix.text.suffix
endfunction

function! airline#get_statusline(winnr, active)
  let builder = airline#builder#new(a:active)

  if airline#util#getwinvar(a:winnr, 'airline_render_left', a:active || (!a:active && !g:airline_inactive_collapse))
    call builder.add_section('a', s:get_section(a:winnr, 'a').'%{g:airline_detect_paste && &paste ? g:airline_paste_symbol." " : ""}')
    call builder.add_section('b', s:get_section(a:winnr, 'b'))
    call builder.add_section('c', s:get_section(a:winnr, 'c').' %#airline_file#%{&ro ? g:airline_readonly_symbol : ""}')
  else
    call builder.add_section('c', '%f%m')
  endif
  call builder.split(s:get_section(a:winnr, 'gutter', '', ''))
  if airline#util#getwinvar(a:winnr, 'airline_render_right', 1)
    call builder.add_section('c', s:get_section(a:winnr, 'x'))
    call builder.add_section('b', s:get_section(a:winnr, 'y'))
    call builder.add_section('a', s:get_section(a:winnr, 'z'))
    if a:active
      call builder.add_raw('%(')
      call builder.add_section('warningmsg', s:get_section(a:winnr, 'warning', '', ''))
      call builder.add_raw('%)')
    endif
  endif

  let info = builder.build()
  call setwinvar(a:winnr, 'airline_current_info', info)
  return info.statusline
endfunction

function! airline#update_statusline()
  if airline#util#exec_funcrefs(g:airline_exclude_funcrefs, 1)
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
  call airline#util#exec_funcrefs(g:airline_statusline_funcrefs, 0)

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
