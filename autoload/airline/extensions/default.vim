" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:section_truncate_width = get(g:, 'airline#extensions#default#section_truncate_width', {
      \ 'b': 88,
      \ 'x': 60,
      \ 'y': 88,
      \ 'z': 45,
      \ })
let s:layout = get(g:, 'airline#extensions#default#layout', [
      \ [ 'a', 'b', 'c' ],
      \ [ 'x', 'y', 'z', 'warning' ]
      \ ])

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

function! s:build_sections(builder, context, keys)
  for key in a:keys
    if key == 'warning' && !a:context.active
      continue
    endif

    " i have no idea why the warning section needs special treatment, but it's
    " needed to prevent separators from showing up
    if key == 'warning'
      call a:builder.add_raw('%(')
    endif
    call a:builder.add_section('airline_'.key, s:get_section(a:context.winnr, key))
    if key == 'warning'
      call a:builder.add_raw('%)')
    endif
  endfor
endfunction

function! airline#extensions#default#apply(builder, context)
  let winnr = a:context.winnr
  let active = a:context.active

  if airline#util#getwinvar(winnr, 'airline_render_left', active || (!active && !g:airline_inactive_collapse))
    call <sid>build_sections(a:builder, a:context, s:layout[0])
  else
    call a:builder.add_section('airline_c'.(a:context.bufnr), ' %f%m ')
  endif

  call a:builder.split(s:get_section(winnr, 'gutter', '', ''))

  if airline#util#getwinvar(winnr, 'airline_render_right', 1)
    call <sid>build_sections(a:builder, a:context, s:layout[1])
  endif

  return 1
endfunction

