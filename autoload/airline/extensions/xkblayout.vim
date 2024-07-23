" MIT License. Copyright (c) 2017-2021 YoungHoon Rhiu et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('g:XkbSwitchLib') && !exists('*FcitxCurrentIM') && !has('nvim')
  finish
endif

function! airline#extensions#xkblayout#status()
  if exists('g:XkbSwitchLib')
    let keyboard_layout = libcall(g:XkbSwitchLib, 'Xkb_Switch_getXkbLayout', '')
    let keyboard_layout = get(split(keyboard_layout, '\.'), -1, '')
  elseif exists('*FcitxCurrentIMwithRime')
    let keyboard_layout = FcitxCurrentIMwithRime()
  elseif exists('*FcitxCurrentIM')
    let keyboard_layout = FcitxCurrentIM()
  elseif has('nvim')
    try
      let keyboard_layout = luaeval('require"ime".current()')
    catch /.*/
      try
        let keyboard_layout = luaeval('require"fcitx5-ui".displayCurrentIM()')
      catch /.*/
        let keyboard_layout = ''
      endtry
    endtry
  else
    let keyboard_layout = ''
  endif
  " substitute keyboard-us to us
  let keyboard_layout = substitute(keyboard_layout, 'keyboard-', '', 'g')

  let short_codes = get(g:, 'airline#extensions#xkblayout#short_codes', {'2SetKorean': 'KR', 'Chinese': 'CN', 'Japanese': 'JP'})
  if has_key(short_codes, keyboard_layout)
    let keyboard_layout = short_codes[keyboard_layout]
  endif

  return keyboard_layout
endfunction

function! airline#extensions#xkblayout#init(ext)
  call airline#parts#define_function('xkblayout', 'airline#extensions#xkblayout#status')
endfunction
