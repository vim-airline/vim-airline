" MIT License. Copyright (c) 2013-2014 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:spc = g:airline_symbols.space

function! airline#extensions#virtualenv#init(ext)
  call a:ext.add_statusline_func('airline#extensions#virtualenv#apply')
endfunction

function! airline#extensions#virtualenv#apply(...)
  if index(split(&filetype, '\.'), 'python') < 0
    return
  endif

  if get(g:, 'pyenv_loaded', 0)
    let statusline = pyenv#statusline#component()
  elseif get(g:, 'virtualenv_loaded', 0)
    let statusline = virtualenv#statusline()
  elseif isdirectory($VIRTUAL_ENV)
    let statusline = fnamemodify($VIRTUAL_ENV, ':t')
  else
    return
  endif

  call airline#extensions#append_to_section('x',
        \ s:spc.g:airline_right_alt_sep.s:spc.statusline)
endfunction

