" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let g:airline_statusline_funcrefs = get(g:, 'airline_statusline_funcrefs', [])

let s:sections = ['a','b','c','gutter','x','y','z','warning']
let s:highlighter = airline#highlighter#new()

function! airline#add_statusline_func(name)
  call airline#add_statusline_funcref(function(a:name))
endfunction

function! airline#add_statusline_funcref(function)
  call add(g:airline_statusline_funcrefs, a:function)
endfunction

function! airline#remove_statusline_func(name)
  let i = index(g:airline_statusline_funcrefs, function(a:name))
  if i > -1
    call remove(g:airline_statusline_funcrefs, i)
  endif
endfunction

function! airline#load_theme()
  call s:highlighter.load_theme()
  call airline#extensions#load_theme()
endfunction

function! airline#switch_theme(name)
  let g:airline_theme = a:name
  let palette = g:airline#themes#{g:airline_theme}#palette "also lazy loads the theme
  call airline#themes#patch(palette)

  if exists('g:airline_theme_patch_func')
    let Fn = function(g:airline_theme_patch_func)
    call Fn(palette)
  endif

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

function! airline#get_statusline(builder, winnr, active)
  if airline#util#getwinvar(a:winnr, 'airline_render_left', a:active || (!a:active && !g:airline_inactive_collapse))
    call a:builder.add_section('airline_a', s:get_section(a:winnr, 'a'))
    call a:builder.add_section('airline_b', s:get_section(a:winnr, 'b'))
    call a:builder.add_section('airline_c', '%<'.s:get_section(a:winnr, 'c'))
  else
    call a:builder.add_section('airline_c', '%f%m')
  endif

  call a:builder.split(s:get_section(a:winnr, 'gutter', '', ''))

  if airline#util#getwinvar(a:winnr, 'airline_render_right', 1)
    call a:builder.add_section('airline_x', s:get_section(a:winnr, 'x'))
    call a:builder.add_section('airline_y', s:get_section(a:winnr, 'y'))
    call a:builder.add_section('airline_z', s:get_section(a:winnr, 'z'))
    if a:active
      call a:builder.add_raw('%(')
      call a:builder.add_section('warningmsg', s:get_section(a:winnr, 'warning', '', ''))
      call a:builder.add_raw('%)')
    endif
  endif

  return a:builder.build()
endfunction

function! airline#update_statusline()
  for nr in filter(range(1, winnr('$')), 'v:val != winnr()')
    call setwinvar(nr, 'airline_active', 0)
    let context = { 'winnr': nr, 'active': 0 }
    let builder = airline#builder#new(context, s:highlighter)
    call setwinvar(nr, '&statusline', airline#get_statusline(builder, nr, 0))
  endfor

  let w:airline_active = 1

  unlet! w:airline_render_left
  unlet! w:airline_render_right
  for section in s:sections
    unlet! w:airline_section_{section}
  endfor

  let context = { 'winnr': winnr(), 'active': 1 }
  let builder = airline#builder#new(context, s:highlighter)
  let err = airline#util#exec_funcrefs(g:airline_statusline_funcrefs, builder)
  if err == 0
    call setwinvar(winnr(), '&statusline', airline#get_statusline(builder, winnr(), 1))
  elseif err == 1
    call setwinvar(winnr(), '&statusline', builder.build())
  endif
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

