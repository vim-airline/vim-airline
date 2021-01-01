" MIT License. Copyright (c) 2013-2021
" Plugin: https://github.com/lambdalisue/fern.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8
if !get(g:, 'fern_loaded', 0)
  finish
endif

function! airline#extensions#fern#apply(...) abort
  if (&ft =~# 'fern')
    let spc = g:airline_symbols.space
    let fri = fern#fri#parse(expand('%f'))

    call a:1.add_section('airline_a', spc.'fern'.spc)
    if exists('*airline#extensions#branch#get_head')
      call a:1.add_section('airline_b', spc.'%{airline#extensions#branch#get_head()}'.spc)
    else
      call a:1.add_section('airline_b', '')
    endif
    if !(fri.authority =~# '^drawer')
      let abspath = substitute(fri.path, 'file://', '', '')
      call a:1.add_section('airline_c', spc.fnamemodify(abspath, ':~'))
      call a:1.split()
      if len(get(g:, 'fern#comparators', {}))
        call a:1.add_section('airline_y', spc.'%{fern#comparator}'.spc)
      endif
    endif
    return 1
  endif
endfunction

function! airline#extensions#fern#init(ext) abort
  let g:fern_force_overwrite_statusline = 0
  call a:ext.add_statusline_func('airline#extensions#fern#apply')
endfunction
