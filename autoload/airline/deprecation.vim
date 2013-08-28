" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#deprecation#check()
  if exists('g:airline_enable_fugitive') || exists('g:airline_fugitive_prefix')
    echom 'The g:airline_enable_fugitive and g:airline_fugitive_prefix variables are obsolete. Please read the documentation about the branch extension.'
  endif

  let tests = [
        \ [ 'g:airline_paste_symbol', 'g:airline_symbols.paste' ],
        \ [ 'g:airline_readonly_symbol', 'g:airline_symbols.readonly' ],
        \ [ 'g:airline_linecolumn_prefix', 'g:airline_symbols.linenr' ],
        \ [ 'g:airline_branch_prefix', 'g:airline_symbols.branch' ],
        \ ]
  for test in tests
    if exists(test[0])
      echom printf('The variable %s is deprecated and may not work in the future. It has been replaced with %s', test[0], test[1])
    endif
  endfor
endfunction

