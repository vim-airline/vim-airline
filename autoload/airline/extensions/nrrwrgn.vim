" MIT License. Copyright (c) 2013-2014 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

if !get(g:, 'loaded_nrrw_rgn', 0)
  finish
endif

function! airline#extensions#nrrwrgn#apply(...)
  if exists(":WidenRegion") == 2
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', printf('%s[Narrowed%s#%d]', spc, spc, b:nrrw_instn))
    if exists('*airline#extensions#branch#get_head')
      call a:1.add_section('airline_b', spc.'%{airline#extensions#branch#get_head()}'.spc)
    endif
    let bufname=(get(b:, 'orig_buf', 0) ? bufname(b:orig_buf) : substitute(bufname('%'), '^Nrrwrgn_\zs.*\ze_\d\+$', submatch(0), ''))
    call a:1.add_section('airline_c', spc.bufname.spc)
    call a:1.split()
    return 1
  endif
endfunction

function! airline#extensions#nrrwrgn#init(ext)
  call a:ext.add_statusline_func('airline#extensions#nrrwrgn#apply')
endfunction
