" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running')

function! airline#highlighter#exec(group, colors)
  let colors = a:colors
  if s:is_win32term
    let colors = map(a:colors, 'v:val != "" && v:val > 128 ? v:val - 128 : v:val')
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

function! s:exec_separator(dict, from, to, invert)
  let l:from = airline#themes#get_highlight(a:from)
  let l:to = airline#themes#get_highlight(a:to)
  let group = a:from.'_to_'.a:to
  let colors = [ l:to[1], l:from[1], l:to[3], l:from[3], a:invert ? 'inverse' : '' ]
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

  function! highlighter.add_separator(from, to, invert)
    let self._separators[a:from.a:to] = [a:from, a:to, a:invert]
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
          call <sid>exec_separator(dict, sep[1][0].suffix, sep[1][1].suffix, sep[1][2])
        endfor
      endif
    endfor
  endfunction

  return highlighter
endfunction

