" MIT License. Copyright (c) 2014-2020 Mathias Andersson et al.
" Plugin: https://github.com/lambdalisue/battery.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('g:loaded_battery')
  finish
endif

function! airline#extensions#battery#status(...) abort
  if !exists('g:battery#update_statusline') 
    let g:battery#update_statusline = 1
  endif
  let w:airline_section_z = '%{battery#component()}'
endfunction

function! airline#extensions#battery#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#battery#status')
endfunction
