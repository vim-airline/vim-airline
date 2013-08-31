" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:empty_message = get(g:, 'airline#extensions#branch#empty_message',
      \ get(g:, 'airline_branch_empty_message', ''))
let s:symbol = get(g:, 'airline#extensions#branch#symbol', g:airline_symbols.branch)

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

  return empty(head)
        \ ? s:empty_message
        \ : printf('%s%s', empty(s:symbol) ? '' : s:symbol.' ', head)
endfunction

function! airline#extensions#branch#init(ext)
  call airline#parts#define_function('branch', 'airline#extensions#branch#get_head')
endfunction

