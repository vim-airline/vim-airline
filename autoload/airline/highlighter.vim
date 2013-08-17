" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2 fdm=indent

let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running')

function! airline#highlighter#exec(group, colors)
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

function! airline#highlighter#exec_separator(from, to)
  if a:from == a:to
    return a:from
  endif
  let l:from = airline#themes#get_highlight(a:from)
  let l:to = airline#themes#get_highlight(a:to)
  let group = a:from.'_to_'.a:to
  call airline#highlighter#exec(group, [ l:to[1], l:from[1], l:to[3], l:from[3] ])
  return group
endfunction


function! airline#highlighter#new()
  let highlighter = {}

  function! highlighter.highlight(modes)
    " draw the base mode, followed by any overrides
    let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
    let suffix = a:modes[0] == 'inactive' ? '_inactive' : ''
    for mode in mapped
      if exists('g:airline#themes#{g:airline_theme}#{mode}')
        for key in keys(g:airline#themes#{g:airline_theme}#{mode})
          let colors = g:airline#themes#{g:airline_theme}#{mode}[key]
          call airline#highlighter#exec(key.suffix, colors)
        endfor
      endif
    endfor
    for sep in w:airline_current_info.separator_groups
      call airline#highlighter#exec_separator(sep[0].suffix, sep[1].suffix)
    endfor
  endfunction

  return highlighter
endfunction

