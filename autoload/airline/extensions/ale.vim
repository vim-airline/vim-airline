" MIT License. Copyright (c) 2013-2017 Bjorn Neergaard, w0rp
" vim: et ts=2 sts=2 sw=2

let s:error_symbol = get(g:, 'airline#extensions#ale#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#ale#warning_symbol', 'W:')

function! airline#extensions#ale#get(type)
  if !exists(':ALELint')
    return ''
  endif

  let l:is_err = a:type ==# 'error'
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:symbol = l:is_err ? s:error_symbol : s:warning_symbol

  if type(l:counts) == type({}) && has_key(l:counts, 'error')
    " Use the current Dictionary format.
    let l:errors = l:counts.error + l:counts.style_error
    let l:num = l:is_err ? l:errors : l:counts.total - l:errors
  else
    " Use the old List format.
    let l:num = l:is_err ? l:counts[0] : l:counts[1]
  endif

  if l:num == 0
    return ''
  else
    return l:symbol . l:num
  endif
endfunction

function! airline#extensions#ale#get_warning()
  return airline#extensions#ale#get('warning')
endfunction

function! airline#extensions#ale#get_error()
  return airline#extensions#ale#get('error')
endfunction

function! airline#extensions#ale#init(ext)
  call airline#parts#define_function('ale_error_count', 'airline#extensions#ale#get_error')
  call airline#parts#define_function('ale_warning_count', 'airline#extensions#ale#get_warning')
endfunction
