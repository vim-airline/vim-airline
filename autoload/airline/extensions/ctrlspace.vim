" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/szw/vim-ctrlspace
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#ctrlspace#statusline(...) abort
  let spc = g:airline_symbols.space
  let l:padding = spc . spc . spc
  let cs = ctrlspace#context#Configuration().Symbols.CS

  let b = airline#builder#new({ 'active': 1 })
  call b.add_section('airline_b', cs . l:padding . ctrlspace#api#StatuslineModeSegment(l:padding))
  call b.split()
  call b.add_section('airline_x', spc . ctrlspace#api#StatuslineTabSegment() . spc)
  return b.build()
endfunction

function! airline#extensions#ctrlspace#init(ext) abort
  let g:CtrlSpaceStatuslineFunction = "airline#extensions#ctrlspace#statusline()"
endfunction
