" MIT License. Copyright (c) 2013-2016 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#deprecation#check()
  if !exists('g:loaded_airline_themes')
    echom 'airline themes have been migrated to github.com/vim-airline/vim-airline-themes and will be removed from the core in the near future.'
  endif
endfunction

