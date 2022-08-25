" Apache 2.0 license. Copyright (c) 2019-2021 Copyright Neovim contributors.
" Plugin: https://github.com/neovim/nvim-lsp
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !(get(g:, 'airline#extensions#nvimlsp#enabled', 1)
      \ && has('nvim')
      \ && luaeval('vim.lsp ~= nil'))
  finish
endif

function! s:airline_nvimlsp_count(cnt, symbol) abort
  return a:cnt ? a:symbol. a:cnt : ''
endfunction

function! airline#extensions#nvimlsp#get(type) abort
  if luaeval('vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    return ''
  endif

  let error_symbol = get(g:, 'airline#extensions#nvimlsp#error_symbol', 'E:')
  let warning_symbol = get(g:, 'airline#extensions#nvimlsp#warning_symbol', 'W:')
  let show_line_numbers = get(g:, 'airline#extensions#nvimlsp#show_line_numbers', 1)

  let is_err = a:type ==# 'Error'

  let symbol = is_err ? error_symbol : warning_symbol

  if luaeval("pcall(require, 'vim.diagnostic')")
    let severity = a:type == 'Warning' ? 'Warn' : a:type
    let num = len(v:lua.vim.diagnostic.get(0, { 'severity': severity }))
  elseif luaeval("pcall(require, 'vim.lsp.diagnostic')")
    let num = v:lua.vim.lsp.diagnostic.get_count(0, a:type)
  else
    let num = v:lua.vim.lsp.util.buf_diagnostics_count(a:type)
  endif

  if show_line_numbers == 1 && luaeval("pcall(require, 'vim.diagnostic')") && num > 0
    return s:airline_nvimlsp_count(num, symbol) . <sid>airline_nvimlsp_get_line_number(num, a:type)
  else
    return s:airline_nvimlsp_count(num, symbol)
  endif
endfunction

function! s:airline_nvimlsp_get_line_number(cnt, type) abort
  let severity = a:type == 'Warning' ? 'Warn' : a:type
  let num = v:lua.vim.diagnostic.get(0, { 'severity': severity })[0].lnum

  let l:open_lnum_symbol  =
    \ get(g:, 'airline#extensions#nvimlsp#open_lnum_symbol', '(L')
  let l:close_lnum_symbol =
    \ get(g:, 'airline#extensions#nvimlsp#close_lnum_symbol', ')')

  return open_lnum_symbol . num . close_lnum_symbol
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
