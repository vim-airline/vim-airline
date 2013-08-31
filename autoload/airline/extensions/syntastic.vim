" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#syntastic#get_warnings()
  let errors = SyntasticStatuslineFlag()
  if strlen(errors) > 0
    return errors.' '
  endif
  return ''
endfunction

function! airline#extensions#syntastic#init(ext)
  call airline#parts#define_function('syntastic', 'airline#extensions#syntastic#get_warnings')
endfunction

