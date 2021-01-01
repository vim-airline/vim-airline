" Apache 2.0 license. Copyright (c) 2019-2021 Copyright Neovim contributors.
" Plugin: https://github.com/neovim/nvim-lsp
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !(get(g:, 'airline#extensions#nvimlsp#enabled', 1)
      \ && exists(':LspInstallInfo'))
  finish
endif

function! s:airline_nvimlsp_count(cnt, symbol) abort
  return a:cnt ? a:symbol. a:cnt : ''
endfunction

function! airline#extensions#nvimlsp#get(type) abort
  if !exists(':LspInstallInfo')
    return ''
  endif

  let error_symbol = get(g:, 'airline#extensions#nvimlsp#error_symbol', 'E:')
  let warning_symbol = get(g:, 'airline#extensions#nvimlsp#warning_symbol', 'W:')

  let is_err = a:type ==# 'Error'

  let symbol = is_err ? error_symbol : warning_symbol

  if luaeval("pcall(require, 'vim.lsp.diagnostic')")
    let num = v:lua.vim.lsp.diagnostic.get_count(0, a:type)
  else
    let num = v:lua.vim.lsp.util.buf_diagnostics_count(a:type)
  endif

  return s:airline_nvimlsp_count(num, symbol)
endfunction

function! airline#extensions#nvimlsp#get_warning() abort
  return airline#extensions#nvimlsp#get('Warning')
endfunction

function! airline#extensions#nvimlsp#get_error() abort
  return airline#extensions#nvimlsp#get('Error')
endfunction

function! airline#extensions#nvimlsp#init(ext) abort
  call airline#parts#define_function('nvimlsp_error_count', 'airline#extensions#nvimlsp#get_error')
  call airline#parts#define_function('nvimlsp_warning_count', 'airline#extensions#nvimlsp#get_warning')
endfunction
