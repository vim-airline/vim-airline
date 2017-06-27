" MIT License. Copyright (c) 2013-2017 Bjorn Neergaard, w0rp
" vim: et ts=2 sts=2 sw=2

let s:error_symbol = get(g:, 'airline#extensions#ale#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#ale#warning_symbol', 'W:')

function! s:airline_ale_count(cnt, symbol)
  return a:cnt ? a:symbol. a:cnt : ''
endfunction

function! airline#extensions#ale#get(type)
  if !exists(':ALELint')
    return ''
  endif

  let is_err = a:type ==# 'error'
  let symbol = is_err ? s:error_symbol : s:warning_symbol

  if !exists('b:airline_extensions_ale_dict')
    let b:airline_extensions_ale_dict = {}
    let b:airline_extensions_ale_dict.error  = 0
    let b:airline_extensions_ale_dict.warning = 0
    let b:airline_extensions_ale_dict.change = 0
  endif

  if b:airline_extensions_ale_dict.change == b:changedtick
    return s:airline_ale_count(b:airline_extensions_ale_dict[a:type], symbol)
  endif

  let is_err = a:type ==# 'error'
  let counts = ale#statusline#Count(bufnr(''))
  let symbol = is_err ? s:error_symbol : s:warning_symbol

  if type(counts) == type({}) && has_key(counts, 'error')
    " Use the current Dictionary format.
    let errors = counts.error + counts.style_error
    let num = is_err ? errors : counts.total - errors
  else
    " Use the old List format.
    let num = is_err ? counts[0] : counts[1]
  endif

  let b:airline_extensions_ale_dict[a:type] = num
  let b:airline_extensions_ale_dict['change'] = b:changedtick

  return s:airline_ale_count(num, symbol)
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
