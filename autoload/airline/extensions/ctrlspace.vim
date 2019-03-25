" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:spc = g:airline_symbols.space
let s:padding = s:spc . s:spc . s:spc
let s:cs = ctrlspace#context#Configuration().Symbols.CS

function! airline#extensions#ctrlspace#statusline(...)
  let b = airline#builder#new({ 'active': 1 })
  call b.add_section('airline_b', s:cs . s:padding . ctrlspace#api#StatuslineModeSegment(s:padding))
  call b.split()
  call b.add_section('airline_x', s:spc . ctrlspace#api#StatuslineTabSegment() . s:spc)
  return b.build()
endfunction

function! airline#extensions#ctrlspace#init(ext)
  let g:CtrlSpaceStatuslineFunction = "airline#extensions#ctrlspace#statusline()"
endfunction
