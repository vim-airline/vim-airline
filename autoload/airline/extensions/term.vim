" MIT License.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#term#apply(...)
  if &buftype == 'terminal'
    let spc = g:airline_symbols.space

    call a:1.add_section('airline_a', spc.'TERMINAL'.spc)
    call a:1.add_section('airline_b', '')
    call a:1.add_section('airline_c', spc.'%f')
    call a:1.split()
    call a:1.add_section('airline_y', '')
    call a:1.add_section('airline_z', spc.airline#section#create_right(['linenr', 'maxlinenr']))
    return 1
  endif
endfunction

function! airline#extensions#term#init(ext)
  call a:ext.add_statusline_func('airline#extensions#term#apply')
endfunction
