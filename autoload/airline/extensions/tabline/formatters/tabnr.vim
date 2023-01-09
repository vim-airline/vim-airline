" MIT License. Copyright (c) 2017-2021 Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#tabnr#format(tab_nr_type, nr)
  " TODO: Is this actually useful? Or should we remove this one?
  let nr = type(a:nr) == type([]) ? a:nr[0] : a:nr
  let spc=g:airline_symbols.space
  if a:tab_nr_type == 0 " nr of splits
    return spc. '%{len(tabpagebuflist('.nr.'))}'
  elseif a:tab_nr_type == 1 " tab number
    return spc. nr
  else "== 2 splits and tab number
    return spc. nr. '.%{len(tabpagebuflist('.nr.'))}'
  endif
endfunction
