" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#branch#init(ext)
  if g:airline_section_b == ''
    let g:airline_section_b =
          \ exists('*fugitive#head') && strlen(fugitive#head()) > 0
            \ ? g:airline_branch_prefix.fugitive#head()
            \ : exists('*lawrencium#statusline') && strlen(lawrencium#statusline()) > 0
              \ ? g:airline_branch_prefix.lawrencium#statusline()
              \ : ''
  endif
endfunction

