" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2
"if !exists('g:eclim_instead_syntastic')
"let g:eclim_instead_syntastic = 0
"endif

"if g:eclim_instead_syntastic == 1
"finish
"endif
if !exists(':ProjectCreate')
  finish
endif

function! airline#extensions#eclim#get_warnings()
  let eclimList = eclim#display#signs#GetExisting()
  if !empty(eclimList)
    let errorsLine = eclimList[0]['line']
    let errorsNumber = len(eclimList)
    let errors = "[Warring: line:".string(errorsLine)." (".string(errorsNumber).")]"
    return errors.(g:airline_symbols.space)
  endif
  return ''
endfunction

function! airline#extensions#eclim#init(ext)
  if !exists('g:eclim_instead_syntastic')
    let g:eclim_instead_syntastic = 1
  endif
  call airline#parts#define_function('eclim', 'airline#extensions#eclim#get_warnings')
endfunction
