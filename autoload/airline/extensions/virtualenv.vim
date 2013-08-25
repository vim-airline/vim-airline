" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#virtualenv#init(ext)
  call a:ext.add_statusline_func('airline#extensions#virtualenv#apply')
endfunction

function! airline#extensions#virtualenv#apply(...)
  if &filetype == "python"
    if !exists('w:airline_section_x')
      let w:airline_section_x = g:airline_section_x
    endif
    let w:airline_section_x = '%{virtualenv#statusline()} '.g:airline_right_alt_sep.' '.w:airline_section_x
  endif
endfunction
