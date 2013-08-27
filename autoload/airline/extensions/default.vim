" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:section_truncate_width = get(g:, 'airline#extensions#default#section_truncate_width', {
      \ 'b': 88,
      \ 'x': 60,
      \ 'y': 88,
      \ 'z': 45,
      \ })

function! s:get_section(winnr, key, ...)
  if has_key(s:section_truncate_width, a:key)
    if winwidth(a:winnr) < s:section_truncate_width[a:key]
      return ''
    endif
  endif
  let text = airline#util#getwinvar(a:winnr, 'airline_section_'.a:key, g:airline_section_{a:key})
  let [prefix, suffix] = [get(a:000, 0, '%( '), get(a:000, 1, ' %)')]
  return empty(text) ? '' : prefix.text.suffix
endfunction

function! airline#extensions#default#apply(builder, context)
  let winnr = a:context.winnr
  let active = a:context.active

  if airline#util#getwinvar(winnr, 'airline_render_left', active || (!active && !g:airline_inactive_collapse))
    call a:builder.add_section('airline_a', s:get_section(winnr, 'a'))
    call a:builder.add_section('airline_b', s:get_section(winnr, 'b'))
    call a:builder.add_section('airline_c', '%<'.s:get_section(winnr, 'c'))
  else
    call a:builder.add_section('airline_c', '%f%m')
  endif

  call a:builder.split(s:get_section(winnr, 'gutter', '', ''))

  if airline#util#getwinvar(winnr, 'airline_render_right', 1)
    call a:builder.add_section('airline_x', s:get_section(winnr, 'x'))
    call a:builder.add_section('airline_y', s:get_section(winnr, 'y'))
    call a:builder.add_section('airline_z', s:get_section(winnr, 'z'))
    if active
      call a:builder.add_raw('%(')
      call a:builder.add_section('airline_warning', s:get_section(winnr, 'warning', '', ''))
      call a:builder.add_raw('%)')
    endif
  endif

  return 1
endfunction

