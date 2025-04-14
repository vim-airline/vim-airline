" MIT License. Copyright (c) 2013-2021
" Plugin: https://github.com/lambdalisue/fern.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8
if !get(g:, 'loaded_fern', 0)
  finish
endif

function! airline#extensions#fern#apply_active(...) abort
  " check if current buffer is both fern and active
  if (&ft =~# 'fern') && a:2.active ==# '1'
    call airline#extensions#fern#configure_sections(a:1, a:2)
    return 1
  endif
endfunction


function! airline#extensions#fern#apply_inactive(...) abort
  " check if referenced buffer is both fern and inactive
  if getbufvar(a:2.bufnr, '&filetype') ==# 'fern' && a:2.active ==# '0'
    call airline#extensions#fern#configure_sections(a:1, a:2)
    return 1
  endif
endfunction

function! airline#extensions#fern#configure_sections(win, context) abort
  let spc = g:airline_symbols.space
  let fri = fern#fri#parse(bufname(a:context.bufnr))
  let abspath = fern#fri#to#filepath(fern#fri#parse(fri.path))
  call a:win.add_section('airline_a', spc.'fern'.spc)
  if exists('*airline#extensions#branch#get_head')
    " because fern navigation changes an internal _fri_ and not the working directory
    " we need to give it some help so the branch name gets updated
    try
      execute 'lcd' fnameescape(abspath)
    catch /^Vim\%((\a\+)\)\=:E344:/
      call a:win.add_section('airline_b', '')
    endtry
    call a:win.add_section('airline_b', spc.'%{airline#extensions#branch#get_head()}'.spc)
  else
    call a:win.add_section('airline_b', '')
  endif
  if !(fri.authority =~# '^drawer')
    call a:win.add_section('airline_c', spc.fnamemodify(abspath, ':~'))
    call a:win.split()
    if len(get(g:, 'fern#comparators', {}))
      call a:win.add_section('airline_y', spc.'%{fern#comparator}'.spc)
    endif
  endif
endfunction

function! airline#extensions#fern#init(ext) abort
  let g:fern_force_overwrite_statusline = 0
  call a:ext.add_statusline_func('airline#extensions#fern#apply_active')
  call a:ext.add_inactive_statusline_func('airline#extensions#fern#apply_inactive')
endfunction
