" MIT License. Copyright (c) 2017-2021 Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#tabnr#format(tab_nr, buflist)
  let spc=g:airline_symbols.space
  let tab_nr_type = get(g:, 'airline#extensions#tabline#tab_nr_type', 0)
  if tab_nr_type == 0 " nr of splits
    return spc. len(tabpagebuflist(a:tab_nr))
  elseif tab_nr_type == 1 " tab number
    " Return only the current tab number
    return spc. a:tab_nr
  else " tab_nr_type == 2 splits and tab number
    " return the tab number followed by the number of buffers (in the tab)
    return spc. a:tab_nr. spc. len(tabpagebuflist(a:tab_nr))
  endif
endfunction
