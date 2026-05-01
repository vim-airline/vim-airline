vim9script

# MIT License. Copyright (c) 2013-2026 Christian Brabandt et al.
# vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

var spc = g:airline_symbols.space
var mouse_support = has('patch-9.2.0386')

def IsTabModified(tabnr: number): bool
  if !g:airline_detect_modified
    return false
  endif
  for bi in tabpagebuflist(tabnr)
    if getbufvar(bi, '&modified')
      return true
    endif
  endfor
  return false
enddef

export def Get(): string
  var tabnr = get(g:, 'actual_curtabpage', tabpagenr())
  var curtab = tabpagenr()
  var label = ''

  if tabnr == 1
    label ..= '%#airline_tabfill#'
    label ..= get(g:, 'airline#extensions#tabpanel#label', '[tabs]') .. "\n"
  endif

  var buflist = tabpagebuflist(tabnr)
  var winnr = tabpagewinnr(tabnr)
  var bufnr = buflist[winnr - 1]
  var title = fnamemodify(bufname(bufnr), ':t')
  if empty(title)
    title = '[No Name]'
  endif

  if tabnr == curtab
    if IsTabModified(tabnr)
      label ..= '%#airline_tabmod#'
    else
      label ..= '%#airline_tabsel#'
    endif
  else
    if IsTabModified(tabnr)
      label ..= '%#airline_tabmod_unsel#'
    else
      label ..= '%#airline_tab#'
    endif
  endif

  if mouse_support
    label ..= '%' .. tabnr .. '[airline#extensions#tabpanel#ClickTab]'
  endif

  if get(g:, 'airline#extensions#tabline#show_tab_nr', 1)
    label ..= spc .. tabnr
    label ..= spc
  endif

  label ..= title .. spc

  if mouse_support
    label ..= '%[]'
  endif
  return label
enddef

export def ClickTab(info: dict<any>): number
  if info.nclicks != 1 || !empty(info.mods)
    return 0
  endif
  if info.button ==# 'l'
    try
      silent execute 'tabnext' info.minwid
    catch
      airline#util#warning('Cannot switch tab')
    endtry
  elseif info.button ==# 'm'
    try
      silent execute 'tabclose' info.minwid
    catch
      airline#util#warning('Cannot close tab')
    endtry
  endif
  return 0
enddef

def LinkHighlights(): void
  highlight! link TabPanelFill airline_tabfill
  highlight! link TabPanelSel airline_tabsel
  highlight! link TabPanel airline_tab
enddef

export def LoadTheme(palette: dict<any>): number
  airline#extensions#tabline#load_theme(palette)
  LinkHighlights()
  return 0
enddef

def Enable(): void
  LinkHighlights()
  &tabpanel = '%!airline#extensions#tabpanel#Get()'
  var cols = get(g:, 'airline#extensions#tabpanel#columns', 20)
  var align = get(g:, 'airline#extensions#tabpanel#align', '')
  var scrollbar = get(g:, 'airline#extensions#tabpanel#scrollbar', 1)
  var opts = 'columns:' .. cols
  if !empty(align)
    opts ..= ',align:' .. align
  endif
  if mouse_support
    if scrollbar
      opts ..= ',scrollbar'
    endif
  endif
  &tabpanelopt = opts
  &showtabpanel = 2
enddef

def Disable(): void
  highlight! link TabPanelFill NONE
  highlight! link TabPanelSel NONE
  highlight! link TabPanel NONE
  &tabpanel = ''
  &tabpanelopt = ''
  &showtabpanel = 0
enddef

export def Init(ext: dict<any>): void
  if !exists('+tabpanel')
    return
  endif

  autocmd_add([{
    group: 'airline_tabpanel',
    event: 'User',
    pattern: 'AirlineToggledOn',
    cmd: 'Enable()',
    replace: true,
  }])
  autocmd_add([{
    group: 'airline_tabpanel',
    event: 'User',
    pattern: 'AirlineToggledOff',
    cmd: 'Disable()',
    replace: true,
  }])

  ext.add_theme_func('airline#extensions#tabpanel#LoadTheme')
  Enable()
enddef
