" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#branch#get_head()
  let head = ''

  if exists('*fugitive#head')
    let head = fugitive#head()
  endif

  if empty(head)
    if exists('*lawrencium#statusline')
      let head = lawrencium#statusline()
    endif
  endif

  return empty(head) ? g:airline_branch_empty_message : g:airline_branch_prefix.head
endfunction

function! airline#extensions#branch#init(ext)
  let g:airline_section_b .= '%{airline#extensions#branch#get_head()}'
endfunction

