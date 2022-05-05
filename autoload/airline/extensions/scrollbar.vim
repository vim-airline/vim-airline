" MIT License. Copyright (c) 2013-2021
" vim: et ts=2 sts=2 sw=2 et

scriptencoding utf-8

function! airline#extensions#scrollbar#calculate() abort
  if winwidth(0) > get(g:, 'airline#extensions#scrollbar#minwidth', 200)
      \ && get(w:, 'airline_active', 0)
    let overwrite = 0
    if &encoding ==? 'utf-8' && !get(g:, 'airline_symbols_ascii', 0)
      let [left, right, middle] = [ '|', '|', '█']
      let overwrite = 1
    else
      let [left, right, middle] = [ '[', ']', '-']
    endif
    let spc = get(g:, 'airline_symbols.space', ' ')
    let width = 20 " max width, plus one border and indicator
    let perc = (line('.') + 0.0) / (line('$') + 0.0)
    let before = float2nr(round(perc * width))
    if before >= 0 && line('.') == 1
      let before = 0
      let left = (overwrite ? '' : left)
    endif
    let after  = width - before
    if (after <= 1 && line('.') == line('$'))
      let after = 0
      let right = (overwrite ? '' : right)
    endif
    return left . repeat(spc,  before) . middle . repeat(spc, after) . right
  else
    return ''
  endif
endfunction

function! airline#extensions#scrollbar#init(ext) abort
  call airline#parts#define_function('scrollbar', 'airline#extensions#scrollbar#calculate')
endfunction
