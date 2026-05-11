" MIT License. Copyright (c) 2013-2021 Bailey Ling Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

call airline#init#bootstrap()

" couple of static variables. Those should not change within a session, thus
" can be initialized here as "static"
let s:spc = g:airline_symbols.space
let s:nomodeline = (v:version > 703 || (v:version == 703 && has("patch438"))) ? '<nomodeline>' : ''
let s:has_strchars = exists('*strchars')
let s:has_strcharpart = exists('*strcharpart')
let s:focusgained_ignore_time = 0

function! airline#util#has_vim9_script()
  " Returns true, if Vim is new enough to understand vim9 script
  return (exists(":def") &&
    \ exists("v:versionlong") &&
    \ v:versionlong >= 8022844 &&
    \ get(g:, "airline_experimental", 0))
endfunction

if !exists(":def") || !airline#util#has_vim9_script()
  " TODO: Try to cache winwidth(0) function
  " e.g. store winwidth per window and access that, only update it, if the size
  " actually changed.
  function! airline#util#winwidth(...) abort
    let nr = get(a:000, 0, 0)
    " When statusline is on top, or using global statusline for Neovim
    " always return the number of columns
    if get(g:, 'airline_statusline_ontop', 0) || &laststatus > 2
      return &columns
    else
      return winwidth(nr)
    endif
  endfunction

  function! airline#util#shorten(text, winwidth, minwidth, ...)
    if airline#util#winwidth() < a:winwidth && len(split(a:text, '\zs')) > a:minwidth
      if get(a:000, 0, 0)
        " shorten from tail
        return '…'.matchstr(a:text, '.\{'.a:minwidth.'}$')
      else
        " shorten from beginning of string
        return matchstr(a:text, '^.\{'.a:minwidth.'}').'…'
      endif
    else
      return a:text
    endif
  endfunction

  function! airline#util#wrap(text, minwidth)
    if a:minwidth > 0 && airline#util#winwidth() < a:minwidth
      return ''
    endif
    return a:text
  endfunction

  function! airline#util#append(text, minwidth)
    if a:minwidth > 0 && airline#util#winwidth() < a:minwidth
      return ''
    endif
    let prefix = s:spc == "\ua0" ? s:spc : s:spc.s:spc
    return empty(a:text) ? '' : prefix.g:airline_left_alt_sep.s:spc.a:text
  endfunction

  function! airline#util#warning(msg)
    echohl WarningMsg
    echomsg "airline: ".a:msg
    echohl Normal
  endfunction

  function! airline#util#prepend(text, minwidth)
    if a:minwidth > 0 && airline#util#winwidth() < a:minwidth
      return ''
    endif
    return empty(a:text) ? '' : a:text.s:spc.g:airline_right_alt_sep.s:spc
  endfunction

  if v:version >= 704
    function! airline#util#getbufvar(bufnr, key, def)
      return getbufvar(a:bufnr, a:key, a:def)
    endfunction
  else
    function! airline#util#getbufvar(bufnr, key, def)
      let bufvals = getbufvar(a:bufnr, '')
      return get(bufvals, a:key, a:def)
    endfunction
  endif

  if v:version >= 704
    function! airline#util#getwinvar(winnr, key, def)
      return getwinvar(a:winnr, a:key, a:def)
    endfunction
  else
    function! airline#util#getwinvar(winnr, key, def)
      let winvals = getwinvar(a:winnr, '')
      return get(winvals, a:key, a:def)
    endfunction
  endif

  if v:version >= 704
    function! airline#util#exec_funcrefs(list, ...)
      for Fn in a:list
        let code = call(Fn, a:000)
        if code != 0
          return code
        endif
      endfor
      return 0
    endfunction
  else
    function! airline#util#exec_funcrefs(list, ...)
      " for 7.2; we cannot iterate the list, hence why we use range()
      " for 7.3-[97, 328]; we cannot reuse the variable, hence the {}
      for i in range(0, len(a:list) - 1)
        let Fn{i} = a:list[i]
        let code = call(Fn{i}, a:000)
        if code != 0
          return code
        endif
      endfor
      return 0
    endfunction
  endif

  " Compatibility wrapper for strchars, in case this vim version does not
  " have it natively
  function! airline#util#strchars(str)
    if s:has_strchars
      return strchars(a:str)
    else
      return strlen(substitute(a:str, '.', 'a', 'g'))
    endif
  endfunction

  function! airline#util#strcharpart(...)
    if s:has_strcharpart
      return call('strcharpart',  a:000)
    else
      " does not handle multibyte chars :(
      return a:1[(a:2):(a:3)]
    endif
  endfunction

  function! airline#util#ignore_buf(name)
    let pat = '\c\v'. get(g:, 'airline#ignore_bufadd_pat', '').
          \ get(g:, 'airline#extensions#tabline#ignore_bufadd_pat',
          \ '!|defx|gundo|nerd_tree|startify|tagbar|term://|undotree|vimfiler')
    return match(a:name, pat) > -1
  endfunction

  function! airline#util#has_fugitive()
    if !exists("s:has_fugitive")
      let s:has_fugitive = exists('*FugitiveHead')
    endif
    return s:has_fugitive
  endfunction

  function! airline#util#has_zhihu()
    if !has('nvim')
      return 0
    endif
    try
      call v:lua.require'zhihu'.setup()
    catch
      return 0
    endtry
    return 1
  endfunction

  function! airline#util#has_gina()
    if !exists("s:has_gina")
      let s:has_gina = (exists(':Gina') && v:version >= 800)
    endif
    return s:has_gina
  endfunction


  function! airline#util#has_lawrencium()
    if !exists("s:has_lawrencium")
      let s:has_lawrencium  = exists('*lawrencium#statusline')
    endif
    return s:has_lawrencium
  endfunction

  function! airline#util#has_vcscommand()
    if !exists("s:has_vcscommand")
      let s:has_vcscommand = exists('*VCSCommandGetStatusLine')
    endif
    return get(g:, 'airline#extensions#branch#use_vcscommand', 0) && s:has_vcscommand
  endfunction

  function! airline#util#has_custom_scm()
    return !empty(get(g:, 'airline#extensions#branch#custom_head', ''))
  endfunction

  function! airline#util#doautocmd(event)
    if !exists('#airline') && a:event !=? 'AirlineToggledOff'
      " airline disabled
      return
    endif
    try
      exe printf("silent doautocmd %s User %s", s:nomodeline, a:event)
    catch /^Vim\%((\a\+)\)\=:E48:/
      " Catch: Sandbox mode
      " no-op
    endtry
  endfunction

  function! airline#util#themes(match)
    let files = split(globpath(&rtp, 'autoload/airline/themes/'.a:match.'*.vim', 1), "\n")
    return sort(map(files, 'fnamemodify(v:val, ":t:r")') + ('random' =~ a:match ? ['random'] : []))
  endfunction

  function! airline#util#stl_disabled(winnr)
    " setting the statusline is disabled,
    " either globally, per window, or per buffer
    " w:airline_disabled is deprecated!
    return get(g:, 'airline_disable_statusline', 0) ||
    \ airline#util#getwinvar(a:winnr, 'airline_disable_statusline', 0) ||
    \ airline#util#getwinvar(a:winnr, 'airline_disabled', 0) ||
    \ airline#util#getbufvar(winbufnr(a:winnr), 'airline_disable_statusline', 0)
  endfunction

  function! airline#util#ignore_next_focusgain()
    if has('win32')
      " Setup an ignore for platforms that trigger FocusLost on calls to
      " system(). macvim (gui and terminal) and Linux terminal vim do not.
      let s:focusgained_ignore_time = localtime()
    endif
  endfunction

  function! airline#util#is_popup_window(winnr)
    " Keep the statusline active if it's a popup window
    if exists('*win_gettype')
      return win_gettype(a:winnr) ==# 'popup' || win_gettype(a:winnr) ==# 'autocmd'
    else
        return airline#util#getwinvar(a:winnr, '&buftype', '') ==# 'popup'
    endif
  endfunction

  function! airline#util#try_focusgained()
    " Ignore lasts for at most one second and is cleared on the first
    " focusgained. We use ignore to prevent system() calls from triggering
    " FocusGained (which occurs 100% on win32 and seem to sometimes occur under
    " tmux).
    let dt = localtime() - s:focusgained_ignore_time
    let s:focusgained_ignore_time = 0
    return dt >= 1
  endfunction

  function! airline#util#has_multiline()
    " Returns true, if Vim supports multiline statusline (Vim 9.2.0083)
    return (exists("+statuslineopt") &&
      \ get(g:, "airline_multiline", 0))
  endfunction

else

  def airline#util#winwidth(...args: list<any>): number
    const nr = get(args, 0, 0)
    # When statusline is on top, or using global statusline for Neovim
    # always return the number of columns
    if get(g:, 'airline_statusline_ontop', 0) || &laststatus > 2
      return &columns
    else
      return winwidth(nr)
    endif
  enddef

  def airline#util#shorten(text: string, winwidth: number, minwidth: number, ...args: list<any>): string
    if airline#util#winwidth() < winwidth && len(split(text, '\zs')) > minwidth
      if get(args, 0, 0)
        # shorten from tail
        return '…' .. matchstr(text, '.\{' .. minwidth .. '}$')
      else
        # shorten from beginning of string
        return matchstr(text, '^.\{' .. minwidth .. '}') .. '…'
      endif
    else
      return text
    endif
  enddef

  def airline#util#wrap(text: string, minwidth: number): string
    if minwidth > 0 && airline#util#winwidth() < minwidth
      return ''
    endif
    return text
  enddef

  def airline#util#append(text: string, minwidth: number): string
    if minwidth > 0 && airline#util#winwidth() < minwidth
      return ''
    endif
    const prefix = s:spc == "\ua0" ? s:spc : s:spc .. s:spc
    return empty(text) ? '' : prefix .. g:airline_left_alt_sep .. s:spc .. text
  enddef

  def airline#util#warning(msg: string)
    echohl WarningMsg
    echomsg "airline: " .. msg
    echohl Normal
  enddef

  def airline#util#prepend(text: string, minwidth: number): string
    if minwidth > 0 && airline#util#winwidth() < minwidth
      return ''
    endif
    return empty(text) ? '' : text .. s:spc .. g:airline_right_alt_sep .. s:spc
  enddef

  def airline#util#getbufvar(bufnr: number, key: string, def: any): any
    return getbufvar(bufnr, key, def)
  enddef

  def airline#util#getwinvar(winnr: number, key: string, def: any): any
    return getwinvar(winnr, key, def)
  enddef

  def airline#util#exec_funcrefs(list: list<any>, ...args: list<any>): number
    for Fn in list
      var code = call(Fn, args)
      if code != 0
        return code
      endif
    endfor
    return 0
  enddef

  def airline#util#strchars(str: string): number
    if s:has_strchars
      return strchars(str)
    else
      return strlen(substitute(str, '.', 'a', 'g'))
    endif
  enddef

  def airline#util#strcharpart(...values: list<any>): string 
    if s:has_strcharpart
      return call('strcharpart',  values)
    else
      # does not handle multibyte chars :(
      return values[1][values[2] : values[3]]
    endif
  enddef

  def airline#util#ignore_buf(name: string): bool
    var pat = '\c\v' .. get(g:, 'airline#ignore_bufadd_pat', '') .. get(g:, 'airline#extensions#tabline#ignore_bufadd_pat', '!|defx|gundo|nerd_tree|startify|tagbar|term://|undotree|vimfiler')
    return match(name, pat) > -1
  enddef

  def airline#util#has_fugitive(): bool
    if !exists("s:has_fugitive")
      s:has_fugitive = exists('*FugitiveHead')
    endif
    return s:has_fugitive
  enddef

  def airline#util#has_zhihu(): number
    return 0
  enddef

  def airline#util#has_gina(): bool
    if !exists("s:has_gina")
      s:has_gina = (exists(':Gina') && v:version >= 800)
    endif
    return s:has_gina
  enddef

  def airline#util#has_lawrencium(): bool 
    if !exists("s:has_lawrencium")
      s:has_lawrencium  = exists('*lawrencium#statusline')
    endif
    return s:has_lawrencium
  enddef

  def airline#util#has_vcscommand(): bool 
    if !exists("s:has_vcscommand")
      s:has_vcscommand = exists('*VCSCommandGetStatusLine')
    endif
    return get(g:, 'airline#extensions#branch#use_vcscommand', 0) && s:has_vcscommand
  enddef

  def airline#util#has_custom_scm(): bool
    return !empty(get(g:, 'airline#extensions#branch#custom_head', ''))
  enddef

  def airline#util#doautocmd(event: string)
    if !exists('#airline') && event !=? 'AirlineToggledOff'
      # airline disabled
      return
    endif
    try
      exe printf("silent doautocmd %s User %s", s:nomodeline, event)
    catch /^Vim\%((\a\+)\)\=:E48:/
      # Catch: Sandbox mode
      # no-op
    endtry
  enddef

  def airline#util#themes(match_str: string): list<string>
    const files = split(globpath(&rtp, 'autoload/airline/themes/' .. match_str .. '*.vim', true), "\n")
    var theme_names = files->mapnew((_, val) => fnamemodify(val, ":t:r"))
    if "random" =~ match_str
      theme_names->add("random")
    endif
    return theme_names->sort()
  enddef

  def airline#util#stl_disabled(winnr: number): bool
    # setting the statusline is disabled,
    # either globally, per window, or per buffer
    # w:airline_disabled is deprecated!
    return get(g:, 'airline_disable_statusline', 0) ||
          \ airline#util#getwinvar(winnr, 'airline_disable_statusline', 0) ||
          \ airline#util#getwinvar(winnr, 'airline_disabled', 0) ||
          \ airline#util#getbufvar(winbufnr(winnr), 'airline_disable_statusline', 0)
  enddef

  def airline#util#ignore_next_focusgain()
    if has('win32')
      # Setup an ignore for platforms that trigger FocusLost on calls to
      # system(). macvim (gui and terminal) and Linux terminal vim do not.
      s:focusgained_ignore_time = localtime()
    endif
  enddef

  def airline#util#is_popup_window(winnr: number): bool
    # Keep the statusline active if it's a popup window
    if exists('*win_gettype')
      return win_gettype(winnr) ==# 'popup' || win_gettype(winnr) ==# 'autocmd'
    else
      return airline#util#getwinvar(winnr, '&buftype', '') ==# 'popup'
    endif
  enddef

  def airline#util#try_focusgained(): bool
    # Ignore lasts for at most one second and is cleared on the first
    # focusgained. We use ignore to prevent system() calls from triggering
    # FocusGained (which occurs 100% on win32 and seem to sometimes occur under
    # tmux).
    const dt = localtime() - s:focusgained_ignore_time
    s:focusgained_ignore_time = 0
    return dt >= 1
  enddef

  def airline#util#has_multiline(): bool
    # Returns true, if Vim supports multiline statusline (Vim 9.2.0083)
    return (exists("+statuslineopt") &&
          \ get(g:, "airline_multiline", 0))
  enddef
endif
