" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running')

function! s:gui2cui(rgb, fallback)
  if a:rgb == ''
    return a:fallback
  endif
  let rgb = map(matchlist(a:rgb, '#\(..\)\(..\)\(..\)')[1:3], '0 + ("0x".v:val)')
  let rgb = [rgb[0] > 127 ? 4 : 0, rgb[1] > 127 ? 2 : 0, rgb[2] > 127 ? 1 : 0]
  return rgb[0]+rgb[1]+rgb[2]
endfunction

function! airline#highlighter#exec(group, colors)
  let colors = a:colors
  if s:is_win32term
    let colors[2] = s:gui2cui(get(colors, 0, ''), get(colors, 2, ''))
    let colors[3] = s:gui2cui(get(colors, 1, ''), get(colors, 3, ''))
  endif
  exec printf('hi %s %s %s %s %s %s %s %s',
        \ a:group,
        \ get(colors, 0, '') != '' ? 'guifg='.colors[0] : '',
        \ get(colors, 1, '') != '' ? 'guibg='.colors[1] : '',
        \ get(colors, 2, '') != '' ? 'ctermfg='.colors[2] : '',
        \ get(colors, 3, '') != '' ? 'ctermbg='.colors[3] : '',
        \ get(colors, 4, '') != '' ? 'gui='.colors[4] : '',
        \ get(colors, 4, '') != '' ? 'cterm='.colors[4] : '',
        \ get(colors, 4, '') != '' ? 'term='.colors[4] : '')
endfunction

function! s:exec_separator(dict, from, to, inverse, suffix)
  let l:from = airline#themes#get_highlight(a:from.a:suffix)
  let l:to = airline#themes#get_highlight(a:to.a:suffix)
  let group = a:from.'_to_'.a:to.a:suffix
  if a:inverse
    let colors = [ l:from[1], l:to[1], l:from[3], l:to[3] ]
  else
    let colors = [ l:to[1], l:from[1], l:to[3], l:from[3] ]
  endif
  let a:dict[group] = colors
  call airline#highlighter#exec(group, colors)
endfunction

function! airline#highlighter#new()
  let highlighter = {}
  let highlighter._separators = {}

  function! highlighter.load_theme()
    call self.highlight(['inactive'])
    call self.highlight(['normal'])
  endfunction

  function! highlighter.add_separator(from, to, inverse)
    let self._separators[a:from.a:to] = [a:from, a:to, a:inverse]
  endfunction

  function! highlighter.highlight(modes)
    " draw the base mode, followed by any overrides
    let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
    let suffix = a:modes[0] == 'inactive' ? '_inactive' : ''
    for mode in mapped
      if exists('g:airline#themes#{g:airline_theme}#palette[mode]')
        let dict = g:airline#themes#{g:airline_theme}#palette[mode]
        for kvp in items(dict)
          call airline#highlighter#exec(kvp[0].suffix, kvp[1])
        endfor

        " TODO: optimize this
        for sep in items(self._separators)
          call <sid>exec_separator(dict, sep[1][0], sep[1][1], sep[1][2], suffix)
        endfor
      endif
    endfor
  endfunction

  return highlighter
endfunction

