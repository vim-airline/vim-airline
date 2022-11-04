" MIT License. Copyright (c) 2021       DEMAREST Maxime (maxime@indelog.fr)
" Plugin: https://github.com/yegappan/lsp
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('*lsp#lsp#ErrorCount')
    finish
endif

let s:error_symbol = get(g:, 'airline#extensions#vim9lsp#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#vim9lsp#warning_symbol', 'W:')

function! airline#extensions#vim9lsp#get_warnings() abort
    let res = get(lsp#lsp#ErrorCount(), 'Warn', 0)
    return res > 0 ? s:warning_symbol . res : ''
endfunction

function! airline#extensions#vim9lsp#get_errors() abort
    let res = get(lsp#lsp#ErrorCount(), 'Error', 0)
    return res > 0 ? s:error_symbol . res : ''
endfunction

function! airline#extensions#vim9lsp#init(ext) abort
  call airline#parts#define_function('vim9lsp_warning_count', 'airline#extensions#vim9lsp#get_warnings')
  call airline#parts#define_function('vim9lsp_error_count', 'airline#extensions#vim9lsp#get_errors')
endfunction
