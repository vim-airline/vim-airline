" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:sections = ['a','b','c','gutter','x','y','z','warning']
let s:highlighter = airline#highlighter#new()

function! airline#load_theme()
  call s:highlighter.load_theme()
  call airline#extensions#load_theme()
endfunction

function! airline#switch_theme(name)
  let g:airline_theme = a:name
  let palette = g:airline#themes#{g:airline_theme}#palette "also lazy loads the theme
  call airline#themes#patch(palette)

  let w:airline_lastmode = ''
  call airline#update_statusline()
  call airline#load_theme()
  call airline#check_mode()
endfunction

function! airline#switch_matching_theme()
  if exists('g:colors_name')
    let v:errmsg = ''
    silent! let palette = g:airline#themes#{g:colors_name}#palette
    if empty(v:errmsg)
      call airline#switch_theme(g:colors_name)
      return 1
    else
      for map in items(g:airline_theme_map)
        if match(g:colors_name, map[0]) > -1
          call airline#switch_theme(map[1])
          return 1
        endif
      endfor
    endif
  endif
  return 0
endfunction

function! s:get_section(winnr, key, ...)
  let text = airline#util#getwinvar(a:winnr, 'airline_section_'.a:key, g:airline_section_{a:key})
  let [prefix, suffix] = [get(a:000, 0, '%( '), get(a:000, 1, ' %)')]
  return empty(text) ? '' : prefix.text.suffix
endfunction

function! airline#get_statusline(winnr, active)
  let builder = airline#builder#new(a:active, s:highlighter)

  if airline#util#getwinvar(a:winnr, 'airline_render_left', a:active || (!a:active && !g:airline_inactive_collapse))
    call builder.add_section('airline_a', s:get_section(a:winnr, 'a')
          \ .'%{g:airline_detect_paste && &paste ? g:airline_paste_symbol." " : ""}')
    call builder.add_section('airline_b', s:get_section(a:winnr, 'b'))
    call builder.add_section('airline_c', '%<'.s:get_section(a:winnr, 'c')
          \ .' %#airline_file#%{&ro ? g:airline_readonly_symbol : ""}')
  else
    call builder.add_section('airline_c', '%f%m')
  endif

  call builder.split(s:get_section(a:winnr, 'gutter', '', ''))

  if airline#util#getwinvar(a:winnr, 'airline_render_right', 1)
    call builder.add_section('airline_c', s:get_section(a:winnr, 'x'))
    call builder.add_section('airline_b', s:get_section(a:winnr, 'y'))
    call builder.add_section('airline_a', s:get_section(a:winnr, 'z'))
    if a:active
      call builder.add_raw('%(')
      call builder.add_section('warningmsg', s:get_section(a:winnr, 'warning', '', ''))
      call builder.add_raw('%)')
    endif
  endif

  return builder.build()
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

function! airline#check_mode()
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

  if g:airline_detect_modified && &modified
    call add(l:mode, 'modified')
  endif
  if g:airline_detect_paste && &paste
    call add(l:mode, 'paste')
  endif

  let mode_string = join(l:mode)
  if get(w:, 'airline_lastmode', '') != mode_string
    call s:highlighter.highlight(l:mode)
    let w:airline_lastmode = mode_string
  endif
  return ''
endfunction

