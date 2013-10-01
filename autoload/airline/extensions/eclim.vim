" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

if !exists(':ProjectCreate')
  finish
endif

function! airline#extensions#eclim#get_warnings()
  let eclimList = eclim#display#signs#GetExisting()
  if !empty(eclimList)
    let errorsLine = eclimList[0]['line']
    let errorsNumber = len(eclimList)
    let errors = "[Eclim: line:".string(errorsLine)." (".string(errorsNumber).")]"
    if !exists(':SyntasticStatuslineFlag') || SyntasticStatuslineFlag() == ''
      return errors.(g:airline_symbols.space)
    endif
  endif
  return ''
endfunction

function! airline#extensions#eclim#init(ext)
  call airline#parts#define_function('eclim', 'airline#extensions#eclim#get_warnings')
endfunction
