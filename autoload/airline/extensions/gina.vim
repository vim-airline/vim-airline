" MIT License. Copyright (c) 2013-2021
" Plugin: https://github.com/lambdalisue/gina.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8
if !get(g:, 'loaded_gina', 0)
  finish
endif

function! airline#extensions#gina#apply(...) abort
  " gina.vim seems to set b:gina_initialized = 1 in diff buffers it open,
  " where get(b:, 'gina_initialized', 0) returns 1.
  " In diff buffers not opened by gina.vim b:gina_initialized is not set,
  " so get(b:, 'gina_initialized', 0) returns 0.
  if (&ft =~# 'gina' && &ft !~# 'blame') || (&ft ==# 'diff' && get(b:, 'gina_initialized', 0))
    call a:1.add_section('airline_a', ' gina ')
    call a:1.add_section('airline_b', ' %{gina#component#repo#branch()} ')
    call a:1.split()
    call a:1.add_section('airline_y', ' staged %{gina#component#status#staged()} ')
    call a:1.add_section('airline_z', ' unstaged %{gina#component#status#unstaged()} ')
    return 1
  endif
endfunction

function! airline#extensions#gina#init(ext) abort
  let g:gina_force_overwrite_statusline = 0
  call a:ext.add_statusline_func('airline#extensions#gina#apply')
endfunction
