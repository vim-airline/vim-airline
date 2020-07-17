" MIT License. Copyright (c) 2013-2020 Bailey Ling et al.
" Plugin: https://github.com/cdelledonne/vim-cmake
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#vimcmake#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#vimcmake#apply')
  call a:ext.add_inactive_statusline_func('airline#extensions#vimcmake#inactive_apply')
endfunction

function! airline#extensions#vimcmake#apply(...) abort
  if &filetype ==# 'vimcmake'
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', spc.'CMake'.spc)
    call a:1.add_section('airline_b', spc.'%{cmake#statusline#GetBuildInfo(1)}'.spc)
    call a:1.add_section('airline_c', spc.'%{cmake#statusline#GetCmdInfo()}'.spc)
    return 1
  endif
endfunction

function! airline#extensions#vimcmake#inactive_apply(...) abort
  if getbufvar(a:2.bufnr, '&filetype') ==# 'vimcmake'
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', spc.'[CMake]')
    call a:1.add_section('airline_b', spc.'%{cmake#statusline#GetBuildInfo(0)}')
    call a:1.add_section('airline_c', spc.'%{cmake#statusline#GetCmdInfo()}')
    return 1
  endif
endfunction
