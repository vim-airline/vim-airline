" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/junegunn/fzf, https://github.com/junegunn/fzf.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#fzf#init(ext) abort
  " Remove the custom statusline that fzf.vim sets by removing its `FileType
  " fzf` autocmd. Ideally we'd use `let g:fzf_statusline = 0`, but this
  " variable is checked *before* airline#extensions#init() is called.
  augroup _fzf_statusline
    autocmd!
  augroup END

  call a:ext.add_statusline_func('airline#extensions#fzf#apply')
  call a:ext.add_inactive_statusline_func('airline#extensions#fzf#inactive_apply')
endfunction

function! airline#extensions#fzf#statusline(...) abort
  let spc = g:airline_symbols.space

  let builder = airline#builder#new({ 'active': 1 })
  call builder.add_section('airline_a', spc.'FZF'.spc)
  call builder.add_section('airline_c', '')
  return builder.build()
endfunction

function! airline#extensions#fzf#apply(...) abort
  if &filetype ==# 'fzf'
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', spc.'FZF'.spc)
    call a:1.add_section('airline_c', '')
    return 1
  endif
endfunction

function! airline#extensions#fzf#inactive_apply(...) abort
  if getbufvar(a:2.bufnr, '&filetype') ==# 'fzf'
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', spc.'FZF'.spc)
    call a:1.add_section('airline_c', '')
    return 1
  endif
endfunction
