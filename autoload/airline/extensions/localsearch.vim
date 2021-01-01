" MIT License. Copyright (c) 2018-2021 mox et al.
" Plugin: https://github.com/mox-mox/vim-localsearch
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:enabled = get(g:, 'airline#extensions#localsearch#enabled', 1)
if !get(g:, 'loaded_localsearch', 0) || !s:enabled || get(g:, 'airline#extensions#localsearch#loaded', 0)
  finish
endif
let g:airline#extensions#localsearch#loaded = 001

let s:spc = g:airline_symbols.space

let g:airline#extensions#localsearch#inverted = get(g:, 'airline#extensions#localsearch#inverted', 0)

function! airline#extensions#localsearch#load_theme(palette) abort
  call airline#highlighter#exec('localsearch_dark', [ '#ffffff' , '#000000' , 15  , 1 , ''])
endfunction


function! airline#extensions#localsearch#init(ext) abort
  call a:ext.add_theme_func('airline#extensions#localsearch#load_theme')
  call a:ext.add_statusline_func('airline#extensions#localsearch#apply')
endfunction


function! airline#extensions#localsearch#apply(...) abort
  " first variable is the statusline builder
  let builder = a:1

  """"" WARNING: the API for the builder is not finalized and may change
  if exists('#localsearch#WinEnter') && !g:airline#extensions#localsearch#inverted " If localsearch mode is enabled and 'invert' option is false
    call builder.add_section('localsearch_dark', s:spc.airline#section#create('LS').s:spc)
  endif
  if !exists('#localsearch#WinEnter') && g:airline#extensions#localsearch#inverted " If localsearch mode is disabled and 'invert' option is true
    call builder.add_section('localsearch_dark', s:spc.airline#section#create('GS').s:spc)
  endif
  return 0
endfunction

