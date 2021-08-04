" MIT License. Copyright (c) 2013-2021 Bailey Ling Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2 et

scriptencoding utf-8

let s:is_win32term = (has('win32') || has('win64')) &&
                   \ !has('gui_running') &&
                   \ (empty($CONEMUBUILD) || &term !=? 'xterm') &&
                   \ empty($WT_SESSION) &&
                   \ !(exists("+termguicolors") && &termguicolors)

let s:separators = {}
let s:accents = {}
let s:hl_groups = {}

if !exists(":def") || !airline#util#has_vim9_script()

  " Legacy Vimscript implementation
  function! s:gui2cui(rgb, fallback) abort
    if a:rgb == ''
      return a:fallback
    elseif match(a:rgb, '^\%(NONE\|[fb]g\)$') > -1
      return a:rgb
    elseif a:rgb[0] !~ '#'
      " a:rgb contains colorname
      return a:rgb
    endif
    let rgb = map(split(a:rgb[1:], '..\zs'), '0 + ("0x".v:val)')
    return airline#msdos#round_msdos_colors(rgb)
  endfunction

  function! s:group_not_done(list, name) abort
    if index(a:list, a:name) == -1
      call add(a:list, a:name)
      return 1
    else
      if &vbs
        echomsg printf("airline: group: %s already done, skipping", a:name)
      endif
      return 0
    endif
  endfu

  function! s:get_syn(group, what, mode) abort
    let color = ''
    if hlexists(a:group)
      let color = synIDattr(synIDtrans(hlID(a:group)), a:what, a:mode)
    endif
    if empty(color) || color == -1
      " should always exist
      let color = synIDattr(synIDtrans(hlID('Normal')), a:what, a:mode)
      " however, just in case
      if empty(color) || color == -1
        let color = 'NONE'
      endif
    endif
    return color
  endfunction

  function! s:get_array(guifg, guibg, ctermfg, ctermbg, opts) abort
    return [ a:guifg, a:guibg, a:ctermfg, a:ctermbg, empty(a:opts) ? '' : join(a:opts, ',') ]
  endfunction

  function! airline#highlighter#reset_hlcache() abort
    let s:hl_groups = {}
  endfunction

  function! airline#highlighter#get_highlight(group, ...) abort
    " only check for the cterm reverse attribute
    " TODO: do we need to check all modes (gui, term, as well)?
    let reverse = synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'cterm')
    if get(g:, 'airline_highlighting_cache', 0) && has_key(s:hl_groups, a:group)
      let res = s:hl_groups[a:group]
      return reverse ? [ res[1], res[0], res[3], res[2], res[4] ] : res
    else
      let ctermfg = s:get_syn(a:group, 'fg', 'cterm')
      let ctermbg = s:get_syn(a:group, 'bg', 'cterm')
      let guifg = s:get_syn(a:group, 'fg', 'gui')
      let guibg = s:get_syn(a:group, 'bg', 'gui')
      let bold = synIDattr(synIDtrans(hlID(a:group)), 'bold')
      if reverse
        let res = s:get_array(guibg, guifg, ctermbg, ctermfg, bold ? ['bold'] : a:000)
      else
        let res = s:get_array(guifg, guibg, ctermfg, ctermbg, bold ? ['bold'] : a:000)
      endif
    endif
    let s:hl_groups[a:group] = res
    return res
  endfunction

  function! airline#highlighter#get_highlight2(fg, bg, ...) abort
    let guifg = s:get_syn(a:fg[0], a:fg[1], 'gui')
    let guibg = s:get_syn(a:bg[0], a:bg[1], 'gui')
    let ctermfg = s:get_syn(a:fg[0], a:fg[1], 'cterm')
    let ctermbg = s:get_syn(a:bg[0], a:bg[1], 'cterm')
    return s:get_array(guifg, guibg, ctermfg, ctermbg, a:000)
  endfunction

  function! s:hl_group_exists(group) abort
    if !hlexists(a:group)
      return 0
    elseif empty(synIDattr(synIDtrans(hlID(a:group)), 'fg'))
      return 0
    endif
    return 1
  endfunction

  function! s:CheckDefined(colors) abort
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
    if empty(bg) || bg < 0
      " in case there is no background color defined for Normal
      let bg = a:colors[3]
    endif
    return a:colors[0:1] + [fg, bg] + [a:colors[4]]
  endfunction

  function! s:GetHiCmd(list) abort
    " a:list needs to have 5 items!
    let res = ''
    let i = -1
    while i < 4
      let i += 1
      let item = get(a:list, i, '')
      if item is ''
        continue
      endif
      if i == 0
        let res .= ' guifg='.item
      elseif i == 1
        let res .= ' guibg='.item
      elseif i == 2
        let res .= ' ctermfg='.item
      elseif i == 3
        let res .= ' ctermbg='.item
      elseif i == 4
        let res .= printf(' gui=%s cterm=%s term=%s', item, item, item)
      endif
    endwhile
    return res
  endfunction

  function! airline#highlighter#load_theme() abort
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

  function! airline#highlighter#add_accent(accent) abort
    let s:accents[a:accent] = 1
  endfunction

  function! airline#highlighter#add_separator(from, to, inverse) abort
    let s:separators[a:from.a:to] = [a:from, a:to, a:inverse]
    call <sid>exec_separator({}, a:from, a:to, a:inverse, '')
  endfunction

  function! s:exec_separator(dict, from, to, inverse, suffix) abort
    if pumvisible()
      return
    endif
    let group = a:from.'_to_'.a:to.a:suffix
    let l:from = airline#themes#get_highlight(a:from.a:suffix)
    let l:to = airline#themes#get_highlight(a:to.a:suffix)
    if a:inverse
      let colors = [ l:from[1], l:to[1], l:from[3], l:to[3] ]
    else
      let colors = [ l:to[1], l:from[1], l:to[3], l:from[3] ]
    endif
    let a:dict[group] = colors
    call airline#highlighter#exec(group, colors)
  endfunction

  function! airline#highlighter#highlight_modified_inactive(bufnr) abort
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

  function! airline#highlighter#exec(group, colors) abort
    if pumvisible()
      return
    endif
    let colors = a:colors
    if len(colors) == 4
      call add(colors, '')
    endif
    " colors should always be string values
    let colors = map(copy(colors), 'type(v:val) != type("") ? string(v:val) : v:val')
    if s:is_win32term
      let colors[2] = s:gui2cui(get(colors, 0, ''), get(colors, 2, ''))
      let colors[3] = s:gui2cui(get(colors, 1, ''), get(colors, 3, ''))
    endif
    let old_hi = airline#highlighter#get_highlight(a:group)
    let new_hi = [colors[0], colors[1], printf('%s', colors[2]), printf('%s', colors[3]), colors[4]]
    let colors = s:CheckDefined(colors)
    if old_hi != new_hi || !s:hl_group_exists(a:group)
      let cmd = printf('hi %s%s', a:group, s:GetHiCmd(colors))
      try
        exe cmd
      catch /^Vim\%((\a\+)\)\=:E421:/ " color definition not found
        let group=matchstr(v:exception, '\w\+\ze=')
        let color=matchstr(v:exception, '=\zs\w\+')
        let cmd=substitute(cmd, color, 'grey', 'g')
        exe cmd
        call airline#util#warning('color definition for group ' . a:group . ' not found, using grey as fallback')
      catch
        call airline#util#warning('Error when running command: '. cmd)
      endtry
      if has_key(s:hl_groups, a:group)
        let s:hl_groups[a:group] = colors
      endif
    endif
  endfunction

  function! airline#highlighter#highlight(modes, ...) abort
    let bufnr = a:0 ? a:1 : ''
    let p = g:airline#themes#{g:airline_theme}#palette

    " draw the base mode, followed by any overrides
    let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
    let suffix = a:modes[0] == 'inactive' ? '_inactive' : ''
    let airline_grouplist = []
    let buffers_in_tabpage = sort(tabpagebuflist())
    if exists("*uniq")
      let buffers_in_tabpage = uniq(buffers_in_tabpage)
    endif
    " mapped might be something like ['normal', 'normal_modified']
    " if a group is in both modes available, only define the second
    " that is how this was done previously overwrite the previous definition
    for mode in reverse(mapped)
      if exists('g:airline#themes#{g:airline_theme}#palette[mode]')
        let dict = g:airline#themes#{g:airline_theme}#palette[mode]
        for kvp in items(dict)
          let mode_colors = kvp[1]
          let name = kvp[0]
          if name is# 'airline_c' && !empty(bufnr) && suffix is# '_inactive'
            let name = 'airline_c'.bufnr
          endif
          " do not re-create highlighting for buffers that are no longer visible
          " in the current tabpage
          if name =~# 'airline_c\d\+'
            let bnr = matchstr(name, 'airline_c\zs\d\+') + 0
            if bnr > 0 && index(buffers_in_tabpage, bnr) == -1
              continue
            endif
          elseif (name =~# '_to_') || (name[0:10] is# 'airline_tab' && !empty(suffix))
            " group will be redefined below at exec_separator
            " or is not needed for tabline with '_inactive' suffix
            " since active flag is 1 for builder)
            continue
          endif
          if s:group_not_done(airline_grouplist, name.suffix)
            call airline#highlighter#exec(name.suffix, mode_colors)
          endif

          if !has_key(p, 'accents')
            " work around a broken installation
            " shouldn't actually happen, p should always contain accents
            continue
          endif

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
            if s:group_not_done(airline_grouplist, name.suffix.'_'.accent)
              call airline#highlighter#exec(name.suffix.'_'.accent, colors)
            endif
          endfor
        endfor

        if empty(s:separators)
          " nothing to be done
          continue
        endif
        " TODO: optimize this
        for sep in items(s:separators)
          " we cannot check, that the group already exists, else the separators
          " might not be correctly defined. But perhaps we can skip above groups
          " that match the '_to_' name, because they would be redefined here...
          call <sid>exec_separator(dict, sep[1][0], sep[1][1], sep[1][2], suffix)
        endfor
      endif
    endfor
  endfunction

  " End legacy VimScript
  finish

else

  " This is using Vim9 script

  def s:gui2cui(rgb: string, fallback: string): string
    if empty(rgb)
      return fallback
    elseif match(rgb, '^\%(NONE\|[fb]g\)$') > -1
      return rgb
    elseif rgb !~ '#'
      # rgb contains colorname
      return rgb
    endif
    var _rgb = []
    _rgb = mapnew(split(rgb[1 : ], '..\zs'), (_, v) => ('0x' .. v)->str2nr(16))
    return airline#msdos#round_msdos_colors(_rgb)
  enddef

  def s:group_not_done(list: list<string>, name: string): bool
    if index(list, name) == -1
      add(list, name)
      return true
    else
      if &vbs
        echomsg printf("airline: group: %s already done, skipping", name)
      endif
      return false
    endif
  enddef

  def s:get_syn(group: string, what: string, mode: string): string
    var color = ''
    if hlexists(group)
      color = hlID(group)->synIDtrans()->synIDattr(what, mode)
    endif
    if empty(color) || str2nr(color) == -1
      # Normal highlighting group should always exist
      color = hlID('Normal')->synIDtrans()->synIDattr(what, mode)
      # however, just in case
      if empty(color) || str2nr(color) == -1
        color = 'NONE'
      endif
    endif
    return color
  enddef

  def s:get_array(guifg: string, guibg: string, ctermfg: string, ctermbg: string, opts: list<string>): list<string>
    return [ guifg, guibg, ctermfg, ctermbg, empty(opts) ? '' : join(opts, ',') ]
  enddef

  def airline#highlighter#reset_hlcache(): void
    s:hl_groups = {}
  enddef

  def airline#highlighter#get_highlight(group: string, rest: list<string> = ['']): list<string>
    # only check for the cterm reverse attribute
    # TODO: do we need to check all modes (gui, term, as well)?
    var reverse = false
    var bold = false
    var property: string
    var res = []
    var ctermfg: string
    var ctermbg: string
    var guifg: string
    var guibg: string
    property = hlID(group)->synIDtrans()->synIDattr('reverse', 'cterm')
    if !empty(property) && property->str2nr()
      reverse = true
    endif
    if get(g:, 'airline_highlighting_cache', 0) && has_key(s:hl_groups, group)
      res = s:hl_groups[group]
      return reverse ? [ res[1], res[0], res[3], res[2], res[4] ] : res
    else
      ctermfg = s:get_syn(group, 'fg', 'cterm')
      ctermbg = s:get_syn(group, 'bg', 'cterm')
      guifg = s:get_syn(group, 'fg', 'gui')
      guibg = s:get_syn(group, 'bg', 'gui')
      property = hlID(group)->synIDtrans()->synIDattr('bold')
      if !empty(property) && property->str2nr()
        bold = true
      endif
      if reverse
        res = s:get_array(guibg, guifg, ctermbg, ctermfg, bold ? ['bold'] : rest)
      else
        res = s:get_array(guifg, guibg, ctermfg, ctermbg, bold ? ['bold'] : rest)
      endif
    endif
    s:hl_groups[group] = res
    return res
  enddef

  def airline#highlighter#get_highlight2(fg: list<string>, bg: list<string>, rest1: string = '', rest2: string = '', rest3: string = ''): list<string>
    var guifg = s:get_syn(fg[0], fg[1], 'gui')
    var guibg = s:get_syn(bg[0], bg[1], 'gui')
    var ctermfg = s:get_syn(fg[0], fg[1], 'cterm')
    var ctermbg = s:get_syn(bg[0], bg[1], 'cterm')
    var rest = [ rest1, rest2, rest3 ]
    return s:get_array(guifg, guibg, ctermfg, ctermbg, filter(rest, (_, v) => !empty(v)))
  enddef

  def s:hl_group_exists(group: string): bool
    if !hlexists(group)
      return false
    elseif hlID(group)->synIDtrans()->synIDattr('fg')->empty()
      return false
    endif
    return true
  enddef

  def s:CheckDefined(colors: list<any>): list<any>
    # Checks, whether the definition of the colors is valid and is not empty or NONE
    # e.g. if the colors would expand to this:
    # hi airline_c ctermfg=NONE ctermbg=NONE
    # that means to clear that highlighting group, therefore, fallback to Normal
    # highlighting group for the cterm values

    # This only works, if the Normal highlighting group is actually defined,
    # so return early, if it has been cleared
    if !exists("g:airline#highlighter#normal_fg_hi")
      g:airline#highlighter#normal_fg_hi = hlID('Normal')->synIDtrans()->synIDattr('fg', 'cterm')
    endif
    if empty(g:airline#highlighter#normal_fg_hi) || str2nr(g:airline#highlighter#normal_fg_hi) < 0
      return colors
    endif

    for val in colors
      if !empty(val) && val !=# 'NONE'
        return colors
      endif
    endfor
    # this adds the bold attribute to the term argument of the :hi command,
    # but at least this makes sure, the group will be defined
    var fg = g:airline#highlighter#normal_fg_hi
    var bg = hlID('Normal')->synIDtrans()->synIDattr('bg', 'cterm')
    if empty(bg) || str2nr(bg) < 0
      # in case there is no background color defined for Normal
      bg = colors[3]
    endif
    return colors[ 0 : 1 ] + [fg, bg] + [colors[4]]
  enddef

  def s:GetHiCmd(list: list<string>): string
    # list needs to have 5 items!
    var res: string
    var i = -1
    var item: string
    while i < 4
      i += 1
      item = get(list, i, '')
      if item is ''
        continue
      endif
      if i == 0
        res ..= ' guifg=' .. item
      elseif i == 1
        res ..= ' guibg=' .. item
      elseif i == 2
        res ..= ' ctermfg=' .. item
      elseif i == 3
        res ..= ' ctermbg=' .. item
      elseif i == 4
        res ..= printf(' gui=%s cterm=%s term=%s', item, item, item)
      endif
    endwhile
    return res
  enddef

  def airline#highlighter#load_theme(): void
    if pumvisible()
      return
    endif
    for winnr in filter(range(1, winnr('$')), (_, v) => v != winnr())
      airline#highlighter#highlight_modified_inactive(winbufnr(winnr))
    endfor
    airline#highlighter#highlight(['inactive'])
    if getbufvar( bufnr('%'), '&modified'  )
      airline#highlighter#highlight(['normal', 'modified'])
    else
      airline#highlighter#highlight(['normal'])
    endif
  enddef

  def airline#highlighter#add_accent(accent: string): void
    s:accents[accent] = 1
  enddef

  def airline#highlighter#add_separator(from: string, to: string, inverse: bool): void
    s:separators[from .. to] = [from, to, inverse]
    s:exec_separator({}, from, to, inverse, '')
  enddef

  def s:exec_separator(dict: dict<any>, from_arg: string, to_arg: string, inverse: bool, suffix: string): void
    if pumvisible()
      return
    endif
    var group = from_arg .. '_to_' .. to_arg .. suffix
    var from = mapnew(airline#themes#get_highlight(from_arg .. suffix), (_, v) => type(v) != type('') ? string(v) : v)
    var colors = []
    var to = mapnew(airline#themes#get_highlight(to_arg .. suffix), (_, v) => type(v) != type('') ? string(v) : v)
    if inverse
      colors = [ from[1], to[1], from[3], to[3] ]
    else
      colors = [ to[1], from[1], to[3], from[3] ]
    endif
    dict[group] = colors
    airline#highlighter#exec(group, colors)
  enddef

  def airline#highlighter#highlight_modified_inactive(bufnr: number): void
    var colors: list<any>
    var dict1  = eval('g:airline#themes#' .. g:airline_theme .. '#palette')->get('inactive_modified', {})
    var dict2  = eval('g:airline#themes#' .. g:airline_theme .. '#palette')->get('inactive', {})

    if empty(dict2)
      return
    endif

    if getbufvar(bufnr, '&modified')
      colors = get(dict1, 'airline_c', [])
    else
      colors = get(dict2, 'airline_c', [])
    endif
    if !empty(colors)
      airline#highlighter#exec('airline_c' .. bufnr .. '_inactive', colors)
    endif
  enddef

  def airline#highlighter#exec(group: string, clrs: list<any>): void
    if pumvisible()
      return
    endif
    var colors: list<string> = mapnew(copy(clrs), (_, v) => type(v) != type('') ? string(v) : v)
    if len(colors) == 4
      add(colors, '')
    endif
    if s:is_win32term
      colors[2] = s:gui2cui(get(colors, 0, ''), get(colors, 2, ''))
      colors[3] = s:gui2cui(get(colors, 1, ''), get(colors, 3, ''))
    endif
    var old_hi: list<string> = airline#highlighter#get_highlight(group)
    var new_hi: list<string> = colors
    if old_hi != new_hi || !s:hl_group_exists(group)
      var cmd = printf('hi %s%s', group, s:GetHiCmd(colors))
      try
        :exe cmd
      catch /^Vim\%((\a\+)\)\=:E421:/
        var grp = matchstr(v:exception, '\w\+\ze=')
        var clr = matchstr(v:exception, '=\zs\w\+')
        cmd = substitute(cmd, clr, 'grey', 'g')
        :exe cmd
        airline#util#warning('color ' .. clr .. ' definition for group ' .. grp .. ' not found, using grey as fallback')
      catch
        airline#util#warning('Error when running command: ' .. cmd)
      endtry
      if has_key(s:hl_groups, group)
        s:hl_groups[group] = colors
      endif
    endif
  enddef

  def airline#highlighter#highlight(modes: list<string>, bufnr: string = ''): void
    var p: dict<any> = eval('g:airline#themes#' .. g:airline_theme .. '#palette')

    # draw the base mode, followed by any overrides
    var mapped = map(modes, (_, v) => v == modes[0] ? v : modes[0] .. "_" .. v)
    var suffix = ''
    if modes[0] == 'inactive'
      suffix = '_inactive'
    endif
    var airline_grouplist = []
    var dict: dict<any>
    var bnr: number = 0

    var buffers_in_tabpage: list<number> = uniq(sort(tabpagebuflist()))
    # mapped might be something like ['normal', 'normal_modified']
    # if a group is in both modes available, only define the second
    # that is how this was done previously overwrite the previous definition
    for mode in reverse(mapped)
      if exists('g:airline#themes#' .. g:airline_theme .. '#palette.' .. mode)
        dict = eval('g:airline#themes#' .. g:airline_theme .. '#palette.' .. mode)
        for kvp in items(dict)
          var mode_colors = kvp[1]
          var name = kvp[0]
          if name == 'airline_c' && !empty(bufnr) && suffix == '_inactive'
            name = 'airline_c' .. bufnr
          endif
          # do not re-create highlighting for buffers that are no longer visible
          # in the current tabpage
          if name =~# 'airline_c\d\+'
            bnr = matchstr(name, 'airline_c\zs\d\+')->str2nr()
            if bnr > 0 && index(buffers_in_tabpage, bnr) == -1
              continue
            endif
          elseif (name =~ '_to_') || (name[ 0 : 10 ] == 'airline_tab' && !empty(suffix))
            # group will be redefined below at exec_separator
            # or is not needed for tabline with '_inactive' suffix
            # since active flag is 1 for builder)
            continue
          endif
          if s:group_not_done(airline_grouplist, name .. suffix)
            airline#highlighter#exec(name .. suffix, mode_colors)
          endif

          if !has_key(p, 'accents')
            # shouldn't actually happen, p should always contain accents
            continue
          endif

          for accent in keys(s:accents)
            if !has_key(p.accents, accent)
              continue
            endif
            var colors = copy(mode_colors)
            if p.accents[accent][0] != ''
                colors[0] = p.accents[accent][0]
            endif
            if type(get(p.accents[accent], 2, '')) == type('')
              colors[2] = get(p.accents[accent], 2, '')
            else
              colors[2] = string(p.accents[accent][2])
            endif
            if len(colors) >= 5
              colors[4] = get(p.accents[accent], 4, '')
            else
              add(colors, get(p.accents[accent], 4, ''))
            endif
            if s:group_not_done(airline_grouplist, name .. suffix .. '_' .. accent)
              airline#highlighter#exec(name .. suffix .. '_' .. accent, colors)
            endif
          endfor
        endfor

        if empty(s:separators)
          continue
        endif
        for sep in items(s:separators)
          # we cannot check, that the group already exists, else the separators
          # might not be correctly defined. But perhaps we can skip above groups
          # that match the '_to_' name, because they would be redefined here...
          s:exec_separator(dict, sep[1][0], sep[1][1], sep[1][2], suffix)
        endfor
      endif
    endfor
	enddef
endif
