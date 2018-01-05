" MIT License. Copyright (c) 2017-2018 C.Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#tabnr#format(tab_nr_type, nr)
  if a:tab_nr_type == 0 " nr of splits
    return (g:airline_symbols.space).'%{len(tabpagebuflist('.a:nr.'))}'
  elseif a:tab_nr_type == 1 " tab number
    return (g:airline_symbols.space).a:nr
  else "== 2 splits and tab number
    return (g:airline_symbols.space).a:nr.'.%{len(tabpagebuflist('.a:nr.'))}'
  endif
endfunction
