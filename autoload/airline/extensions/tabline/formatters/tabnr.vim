" MIT License. Copyright (c) 2017-2021 Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#tabnr#format(nr, buflist)
  let spc=g:airline_symbols.space

  return printf("%s %d/%d", spc, a:nr,  len(tabpagebuflist(a:nr)))
endfunction
