" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running')
let s:separators = {}

function! s:gui2cui(rgb, fallback)
  if a:rgb == ''
    return a:fallback
  endif
  let rgb = map(matchlist(a:rgb, '#\(..\)\(..\)\(..\)')[1:3], '0 + ("0x".v:val)')
  let rgb = [rgb[0] > 127 ? 4 : 0, rgb[1] > 127 ? 2 : 0, rgb[2] > 127 ? 1 : 0]
  return rgb[0]+rgb[1]+rgb[2]
endfunction

function! s:get_syn(group, what)
  " need to pass in mode, known to break on 7.3.547
  let mode = has('gui_running') ? 'gui' : 'cterm'
  let color = synIDattr(synIDtrans(hlID(a:group)), a:what, mode)
  if empty(color) || color == -1
    let color = synIDattr(synIDtrans(hlID('Normal')), a:what, mode)
  endif
  if empty(color) || color == -1
    if has('gui_running')
      let color = a:what ==# 'fg' ? '#000000' : '#FFFFFF'
    else
      let color = a:what ==# 'fg' ? 0 : 1
    endif
  endif
  return color
endfunction

function! s:get_array(fg, bg, opts)
  let fg = a:fg
  let bg = a:bg
  return has('gui_running')
        \ ? [ fg, bg, '', '', join(a:opts, ',') ]
        \ : [ '', '', fg, bg, join(a:opts, ',') ]
endfunction

function! airline#highlighter#get_highlight(group, ...)
  let fg = s:get_syn(a:group, 'fg')
  let bg = s:get_syn(a:group, 'bg')
  let reverse = synIDattr(synIDtrans(hlID(a:group)), 'reverse', has('gui_running') ? 'gui' : 'term')
  return reverse ? s:get_array(bg, fg, a:000) : s:get_array(fg, bg, a:000)
endfunction

function! airline#highlighter#get_highlight2(fg, bg, ...)
  let fg = s:get_syn(a:fg[0], a:fg[1])
  let bg = s:get_syn(a:bg[0], a:bg[1])
  return s:get_array(fg, bg, a:000)
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

function! airline#highlighter#load_theme()
  for winnr in filter(range(1, winnr('$')), 'v:val != winnr()')
    call airline#highlighter#highlight_modified_inactive(winbufnr(winnr))
  endfor
  call airline#highlighter#highlight(['inactive'])
  call airline#highlighter#highlight(['normal'])
endfunction

function! airline#highlighter#add_separator(from, to, inverse)
  let s:separators[a:from.a:to] = [a:from, a:to, a:inverse]
  call <sid>exec_separator({}, a:from, a:to, a:inverse, '')
endfunction

function! airline#highlighter#add_accent(group, accent)
  let p = g:airline#themes#{g:airline_theme}#palette
  if exists('p.accents')
    if has_key(p.accents, a:accent)
      for kvp in items(p)
        let mode_colors = kvp[1]
        if has_key(mode_colors, a:group)
          let colors = copy(mode_colors[a:group])
          if p.accents[a:accent][0] != ''
            let colors[0] = p.accents[a:accent][0]
          endif
          if p.accents[a:accent][2] != ''
            let colors[2] = p.accents[a:accent][2]
          endif
          let colors[4] = get(p.accents[a:accent], 4, '')
          let mode_colors[a:group.'_'.a:accent] = colors
        endif
      endfor
    endif
  endif
endfunction

function! airline#highlighter#highlight_modified_inactive(bufnr)
  if getbufvar(a:bufnr, '&modified')
    let colors = exists('g:airline#themes#{g:airline_theme}#palette.inactive_modified.airline_c')
          \ ? g:airline#themes#{g:airline_theme}#palette.inactive_modified.airline_c : []
  else
    let colors = exists('g:airline#themes#{g:airline_theme}#palette.inactive.airline_c')
          \ ? g:airline#themes#{g:airline_theme}#palette.inactive.airline_c : []
  endif

  if !empty(colors)
    call airline#highlighter#exec('airline_c'.(a:bufnr).'_inactive', colors)
  endif
endfunction

function! airline#highlighter#highlight(modes)
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
      for sep in items(s:separators)
        call <sid>exec_separator(dict, sep[1][0], sep[1][1], sep[1][2], suffix)
      endfor
    endif
  endfor
endfunction

