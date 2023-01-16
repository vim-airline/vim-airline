" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#short_path_improved#format(bufnr, buffers) abort
  let name = bufname(a:bufnr)
  if empty(name)
    return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, '[No Name]')
  endif

  let tail = s:tail(a:bufnr)
  let tails = s:tails(a:bufnr, a:buffers)

  if has_key(tails, tail)
    " Use short path for duplicates
    return airline#extensions#tabline#formatters#short_path#format(a:bufnr, a:buffers)
  endif

  " Use tail for unique filenames
  return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, tail)
endfunction

function! s:tails(self, buffers) abort
  let tails = {}
  for nr in a:buffers
    if nr != a:self
      let tails[s:tail(nr)] = 1
    endif
  endfor
  return tails
endfunction

function! s:tail(bufnr) abort
  return fnamemodify(bufname(a:bufnr), ':t')
endfunction
