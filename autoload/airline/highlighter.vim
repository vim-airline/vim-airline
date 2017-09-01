" MIT License. Copyright (c) 2013-2016 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:is_win32term = (has('win32') || has('win64')) &&
                   \ !has('gui_running') &&
                   \ (empty($CONEMUBUILD) || &term !=? 'xterm') &&
                   \ !(exists("+termguicolors") && &termguicolors)

let s:separators = {}
let s:accents = {}
let s:hl_groups = {}

function! s:gui2cui(rgb, fallback)
  if a:rgb == ''
    return a:fallback
  elseif match(a:rgb, '^\%(NONE\|[fb]g\)$') > -1
    return a:rgb
  endif
  let rgb = map(split(a:rgb[1:], '..\zs'), '0 + ("0x".v:val)')
  return airline#msdos#round_msdos_colors(rgb)
endfunction

function! s:get_syn(group, what)
  if !exists("g:airline_gui_mode")
    let g:airline_gui_mode = airline#init#gui_mode()
  endif
  let color = ''
  if hlexists(a:group)
    let color = synIDattr(synIDtrans(hlID(a:group)), a:what, g:airline_gui_mode)
  endif
  if empty(color) || color == -1
    " should always exists
    let color = synIDattr(synIDtrans(hlID('Normal')), a:what, g:airline_gui_mode)
    " however, just in case
    if empty(color) || color == -1
      let color = 'NONE'
    endif
  endif
  return color
endfunction

function! s:get_array(fg, bg, opts)
  let opts=empty(a:opts) ? '' : join(a:opts, ',')
  return g:airline_gui_mode ==# 'gui'
        \ ? [ a:fg, a:bg, '', '', opts ]
        \ : [ '', '', a:fg, a:bg, opts ]
endfunction

function! airline#highlighter#reset_hlcache()
  let s:hl_groups = {}
endfunction

function! airline#highlighter#get_highlight(group, ...)
  if get(g:, 'airline_highlighting_cache', 0) && has_key(s:hl_groups, a:group)
    return s:hl_groups[a:group]
  else
    let fg = s:get_syn(a:group, 'fg')
    let bg = s:get_syn(a:group, 'bg')
    let reverse = g:airline_gui_mode ==# 'gui'
          \ ? synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'gui')
          \ : synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'cterm')
          \|| synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'term')
    let bold = synIDattr(synIDtrans(hlID(a:group)), 'bold')
    let opts = a:000
    if bold
      let opts = ['bold']
    endif
    let res = reverse ? s:get_array(bg, fg, opts) : s:get_array(fg, bg, opts)
  endif
  let s:hl_groups[a:group] = res
  return res
endfunction

function! airline#highlighter#get_highlight2(fg, bg, ...)
  let fg = s:get_syn(a:fg[0], a:fg[1])
  let bg = s:get_syn(a:bg[0], a:bg[1])
  return s:get_array(fg, bg, a:000)
endfunction

function! s:hl_group_exists(group)
  if !hlexists(a:group)
    return 0
  elseif empty(synIDattr(hlID(a:group), 'fg'))
    return 0
  endif
  return 1
endfunction

function! airline#highlighter#exec(group, colors)
  if pumvisible()
    return
  endif
  let colors = a:colors
  if s:is_win32term
    let colors[2] = s:gui2cui(get(colors, 0, ''), get(colors, 2, ''))
    let colors[3] = s:gui2cui(get(colors, 1, ''), get(colors, 3, ''))
  endif
  let old_hi = airline#highlighter#get_highlight(a:group)
  if len(colors) == 4
    call add(colors, '')
  endif
  if g:airline_gui_mode ==# 'gui'
    let new_hi = [colors[0], colors[1], '', '', colors[4]]
  else
    let new_hi = ['', '', printf("%s", colors[2]), printf("%s", colors[3]), colors[4]]
  endif
  let colors = s:CheckDefined(colors)
  if old_hi != new_hi || !s:hl_group_exists(a:group)
    let cmd = printf('hi %s %s %s %s %s %s %s %s',
        \ a:group, s:Get(colors, 0, 'guifg='), s:Get(colors, 1, 'guibg='),
        \ s:Get(colors, 2, 'ctermfg='), s:Get(colors, 3, 'ctermbg='),
        \ s:Get(colors, 4, 'gui='), s:Get(colors, 4, 'cterm='),
        \ s:Get(colors, 4, 'term='))
    exe cmd
    if has_key(s:hl_groups, a:group)
      let s:hl_groups[a:group] = colors
    endif
  endif
endfunction

function! s:CheckDefined(colors)
  " Checks, whether the definition of the colors is valid and is not empty or NONE
  " e.g. if the colors would expand to this:
  " hi airline_c ctermfg=NONE ctermbg=NONE
  " that means to clear that highlighting group, therefore, fallback to Normal
  " highlighting group for the cterm values

  " This only works, if the Normal highlighting group is actually defined, so
  " return early, if it has been cleared
  if !exists("g:airline#highlighter#normal_fg_hi")
    let g:airline#highlighter#normal_fg_hi = synIDattr(synIDtrans(hlID('Normal')), 'fg', 'cterm')
  endif
  if empty(g:airline#highlighter#normal_fg_hi) || g:airline#highlighter#normal_fg_hi < 0
    return a:colors
  endif

  for val in a:colors
    if !empty(val) && val !=# 'NONE'
      return a:colors
    endif
  endfor
  " this adds the bold attribute to the term argument of the :hi command,
  " but at least this makes sure, the group will be defined
  let fg = g:airline#highlighter#normal_fg_hi
  let bg = synIDattr(synIDtrans(hlID('Normal')), 'bg', 'cterm')
  if bg < 0
    " in case there is no background color defined for Normal
    let bg = a:colors[3]
  endif
  return a:colors[0:1] + [fg, bg] + [a:colors[4]]
endfunction

function! s:Get(dict, key, prefix)
  let res=get(a:dict, a:key, '')
  if res is ''
    return ''
  else
    return a:prefix. res
  endif
endfunction

function! s:exec_separator(dict, from, to, inverse, suffix)
  if pumvisible()
    return
  endif
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
  if pumvisible()
    return
  endif
  for winnr in filter(range(1, winnr('$')), 'v:val != winnr()')
    call airline#highlighter#highlight_modified_inactive(winbufnr(winnr))
  endfor
  call airline#highlighter#highlight(['inactive'])
  if getbufvar( bufnr('%'), '&modified'  )
    call airline#highlighter#highlight(['normal', 'modified'])
  else
    call airline#highlighter#highlight(['normal'])
  endif
endfunction

function! airline#highlighter#add_separator(from, to, inverse)
  let s:separators[a:from.a:to] = [a:from, a:to, a:inverse]
  call <sid>exec_separator({}, a:from, a:to, a:inverse, '')
endfunction

function! airline#highlighter#add_accent(accent)
  let s:accents[a:accent] = 1
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

function! airline#highlighter#highlight(modes, ...)
  let bufnr = a:0 ? a:1 : ''
  let p = g:airline#themes#{g:airline_theme}#palette

  " draw the base mode, followed by any overrides
  let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
  let suffix = a:modes[0] == 'inactive' ? '_inactive' : ''
  for mode in mapped
    if mode == 'inactive' && winnr('$') == 1
      " there exist no inactive windows, don't need to create all those
      " highlighting groups
      continue
    endif
    if exists('g:airline#themes#{g:airline_theme}#palette[mode]')
      let dict = g:airline#themes#{g:airline_theme}#palette[mode]
      for kvp in items(dict)
        let mode_colors = kvp[1]
        let name = kvp[0]
        if name is# 'airline_c' && !empty(bufnr) && suffix is# '_inactive'
          let name = 'airline_c'.bufnr
        endif
        call airline#highlighter#exec(name.suffix, mode_colors)

        for accent in keys(s:accents)
          if !has_key(p.accents, accent)
            continue
          endif
          let colors = copy(mode_colors)
          if p.accents[accent][0] != ''
            let colors[0] = p.accents[accent][0]
          endif
          if p.accents[accent][2] != ''
            let colors[2] = p.accents[accent][2]
          endif
          if len(colors) >= 5
            let colors[4] = get(p.accents[accent], 4, '')
          else
            call add(colors, get(p.accents[accent], 4, ''))
          endif
          call airline#highlighter#exec(name.suffix.'_'.accent, colors)
        endfor
      endfor

      " TODO: optimize this
      for sep in items(s:separators)
        call <sid>exec_separator(dict, sep[1][0], sep[1][1], sep[1][2], suffix)
      endfor
    endif
  endfor
endfunction
