" MIT License. Copyright (c) 2014-2026 Mathias Andersson et al.
" Plugin: https://github.com/milanglacier/minuet-ai.nvim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !has('nvim') || !luaeval("package.loaded['minuet'] ~= nil")
  finish
endif

let g:airline_minuet_pending = 0

augroup AirlineMinuetStatus
    autocmd!
    autocmd User MinuetRequestStarted
        \ let g:airline_minuet_pending += 1
    autocmd User MinuetRequestFinished
        \ let g:airline_minuet_pending = max([0, g:airline_minuet_pending - 1])
augroup END

function! airline#extensions#minuet#status() abort
  return '{…}' . (g:airline_minuet_pending > 0 ? ' ' . g:airline_minuet_pending : '')
endfunction

function! airline#extensions#minuet#init(ext) abort
  call airline#parts#define_function('minuet', 'airline#extensions#minuet#status')
endfunction
