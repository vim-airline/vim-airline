" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:has_fugitive = exists('*fugitive#head')
let s:has_fugitive_detect = exists('*fugitive#detect')
let s:has_lawrencium = exists('*lawrencium#statusline')

function! airline#extensions#branch#get_head()
  let head = ''

  if s:has_fugitive && !exists('b:mercurial_dir')
    let head = fugitive#head()

    if empty(head) && s:has_fugitive_detect && !exists('b:git_dir')
      call fugitive#detect(getcwd())
      let head = fugitive#head()
    endif
  endif

  if empty(head)
    if s:has_lawrencium
      let head = lawrencium#statusline()
    endif
  endif

  return empty(head) ? g:airline_branch_empty_message : g:airline_branch_prefix.head
endfunction

function! airline#extensions#branch#init(ext)
  let g:airline_section_b .= '%{airline#extensions#branch#get_head()}'
endfunction

