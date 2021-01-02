" MIT License. Copyright (c) 2013-2021 François-Xavier Carton et al.
" Plugin: https://github.com/prabirshrestha/vim-lsp
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'lsp_loaded', 0)
  finish
endif

function! s:airline_lsp_count(cnt, symbol) abort
  return a:cnt ? a:symbol. a:cnt : ''
endfunction

function! s:airline_lsp_get_line_number(cnt, type) abort
  let result = ''

  if a:type ==# 'error'
    let result = lsp#get_buffer_first_error_line()
  endif

  if empty(result)
      return ''
  endif

  let open_lnum_symbol  =
    \ get(g:, 'airline#extensions#lsp#open_lnum_symbol', '(L')
  let close_lnum_symbol =
    \ get(g:, 'airline#extensions#lsp#close_lnum_symbol', ')')

  return open_lnum_symbol . result . close_lnum_symbol
endfunction

function! airline#extensions#lsp#get(type) abort
  if !exists(':LspDeclaration')
    return ''
  endif

  let error_symbol = get(g:, 'airline#extensions#lsp#error_symbol', 'E:')
  let warning_symbol = get(g:, 'airline#extensions#lsp#warning_symbol', 'W:')
  let show_line_numbers = get(g:, 'airline#extensions#lsp#show_line_numbers', 1)

  let is_err = a:type ==# 'error'

  let symbol = is_err ? error_symbol : warning_symbol

  let num = lsp#get_buffer_diagnostics_counts()[a:type]

  if show_line_numbers == 1
    return s:airline_lsp_count(num, symbol) . <sid>airline_lsp_get_line_number(num, a:type)
  else
    return s:airline_lsp_count(num, symbol)
  endif
endfunction

function! airline#extensions#lsp#get_warning() abort
  return airline#extensions#lsp#get('warning')
endfunction

function! airline#extensions#lsp#get_error() abort
  return airline#extensions#lsp#get('error')
endfunction

let s:lsp_progress = []
function! airline#extensions#lsp#progress() abort
  if get(w:, 'airline_active', 0)
    if exists('*lsp#get_progress')
      let s:lsp_progress = lsp#get_progress()

      if len(s:lsp_progress) == 0 | return '' | endif

      " show only most new progress
      let s:lsp_progress = s:lsp_progress[0]
      if s:lsp_progress['message'] !=# '' && s:lsp_progress['percentage'] !=# 100
        let percent = ''
        if s:lsp_progress['percentage'] >= 0
          let percent = ' ' . string(s:lsp_progress['percentage']) . '%'
        endif
        let s:title = s:lsp_progress['title']
        let message = airline#util#shorten(s:lsp_progress['message'] . percent, 91, 9)
        return s:lsp_progress['server'] . ':' . s:title . ' ' . message
      endif
      return ''
    endif
  endif
endfunction

let s:timer = 0
let s:ignore_time = 0
function! airline#extensions#lsp#update() abort
  if reltimefloat(reltime()) - s:ignore_time >=
        \ get(g:, 'airline#extensions#lsp#progress_skip_time', 0.3)
        \ || len(s:lsp_progress) == 0
    call airline#update_statusline()
    let s:ignore_time = reltimefloat(reltime())
  endif
endfunction

function! airline#extensions#lsp#init(ext) abort
  call airline#parts#define_function('lsp_error_count', 'airline#extensions#lsp#get_error')
  call airline#parts#define_function('lsp_warning_count', 'airline#extensions#lsp#get_warning')
  call airline#parts#define_function('lsp_progress', 'airline#extensions#lsp#progress')
  augroup airline_lsp_progress
    autocmd!
    autocmd User lsp_progress_updated call airline#extensions#lsp#update()
  augroup END
endfunction
