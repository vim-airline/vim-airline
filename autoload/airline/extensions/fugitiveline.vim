" MIT License. Copyright (c) 2017 Cimbali.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('*fugitive#head')
  finish
endif


if exists("+autochdir") && &autochdir == 1
  let s:fmod = ':p'
else
  let s:fmod = ':.'
endif

function! airline#extensions#fugitiveline#bufname()
  try
    let buffer = fugitive#buffer()
    if buffer.type('blob')
      return fnamemodify(buffer.repo().translate(buffer.path()), s:fmod)
    endif
  catch
  endtry

  return fnamemodify(bufname('%'), s:fmod)
endfunction

function! airline#extensions#fugitiveline#init(ext)
  if exists("+autochdir") && &autochdir == 1
    " if 'acd' is set, vim-airline uses the path section, so we need to redefine this here as well
    call airline#parts#define_raw('path', '%<%{airline#extensions#fugitiveline#bufname()}%m')
  else
    call airline#parts#define_raw('file', '%<%{airline#extensions#fugitiveline#bufname()}%m')
  endif
endfunction

