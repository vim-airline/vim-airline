" MIT License. Copyright (c) 2017-2021 C.Brabandt et al.
" Plugin: https://github.com/tpope/vim-fugitive
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !airline#util#has_fugitive()
  finish
endif

function! airline#extensions#projectdir#Dir() abort
  let dir = FugitiveGitDir(bufnr(''))
  return empty(dir) ? '' : pathshorten(fnamemodify(simplify(dir .. '/../'), ':h:t'))
endfunction

function! airline#extensions#projectdir#init(ext) abort
  call airline#parts#define_raw('projectdir', '%{airline#extensions#projectdir#Dir()}')
endfunction
