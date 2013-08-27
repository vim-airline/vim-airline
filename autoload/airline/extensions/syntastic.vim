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
  let g:airline_parts.syntastic = '%{airline#extensions#syntastic#get_warnings()}'
endfunction

