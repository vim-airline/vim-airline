" MIT License. Copyright (c) 2013-2021 Doron Behar, C.Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !has('keymap')
  finish
endif

function! airline#extensions#keymap#status()
  if (get(g:, 'airline#extensions#keymap#enabled', 1) && has('keymap'))
    let short_codes = get(g:, 'airline#extensions#keymap#short_codes', {})
    let label = get(g:, 'airline#extensions#keymap#label', g:airline_symbols.keymap)
    let default = get(g:, 'airline#extensions#keymap#default', '')
    if (label !=# '')
      let label .= ' '
    endif
    let keymap = &keymap
    if has_key(short_codes, keymap)
      let keymap = short_codes[keymap]
    endif
    return printf('%s', (!empty(keymap) && &iminsert ? (label . keymap) :
          \ (!empty(default) ? label . default : default)))
  else
    return ''
  endif
endfunction

function! airline#extensions#keymap#init(ext)
  call airline#parts#define_function('keymap', 'airline#extensions#keymap#status')
endfunction
