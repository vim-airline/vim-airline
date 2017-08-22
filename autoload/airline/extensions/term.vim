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
    redraw!
    return 1
    "let w:airline_section_b = ''
    "let w:airline_section_x = ''
    " Here we define a new part for the plugin.  This allows users to place this
    " extension in arbitrary locations.
    "call airline#parts#define_raw('term', '%{airline#extensions#term#get_highlight()}')

    " Next up we add a funcref so that we can run some code prior to the
    " statusline getting modifed.
    "call a:ext.add_statusline_func('airline#extensions#term#apply')
  endif
endfunction

function! airline#extensions#term#init(ext)
  call a:ext.add_statusline_func('airline#extensions#term#apply')
endfunction
