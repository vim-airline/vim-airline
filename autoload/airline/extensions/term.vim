" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#term#apply(...)
  if &buftype == 'terminal'
    let spc = g:airline_symbols.space

    let name=get(g:airline_mode_map, 't', 't')
    call a:1.add_section('airline_a', spc.name.spc)
    call a:1.add_section('airline_b', '')
    call a:1.add_section('airline_term', spc.s:termname())
    call a:1.split()
    call a:1.add_section('airline_y', '')
    call a:1.add_section('airline_z', spc.airline#section#create_right(['linenr', 'maxlinenr']))
    return 1
  endif
endfunction

function! airline#extensions#term#inactive_apply(...)
  if getbufvar(a:2.bufnr, '&buftype') == 'terminal'
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', spc.'TERMINAL'.spc)
    call a:1.add_section('airline_b', spc.'%f')
    return 1
  endif
endfunction

function! s:termname()
  let bufname = bufname('%')
  if has('nvim')
    return matchstr(bufname, 'term.*:\zs.*')
  else
    " get rid of leading '!'
    return bufname[1:]
  endif
endfunction

function! airline#extensions#term#init(ext)
  call a:ext.add_statusline_func('airline#extensions#term#apply')
  call a:ext.add_inactive_statusline_func('airline#extensions#term#inactive_apply')
endfunction
