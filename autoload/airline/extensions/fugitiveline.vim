" MIT License. Copyright (c) 2017-2018 Cimbali et al
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
  if !exists('b:fugitive_name')
    let b:fugitive_name = ''
    try
      let buffer = fugitive#buffer()
      if buffer.type('blob')
        let b:fugitive_name = buffer.repo().translate(buffer.path())
      endif
    catch
    endtry
  endif

  if empty(b:fugitive_name)
    return fnamemodify(bufname('%'), s:fmod)
  else
    return fnamemodify(b:fugitive_name, s:fmod)
  endif
endfunction

function! airline#extensions#fugitiveline#init(ext)
  if exists("+autochdir") && &autochdir == 1
    " if 'acd' is set, vim-airline uses the path section, so we need to redefine this here as well
    call airline#parts#define_raw('path', '%<%{airline#extensions#fugitiveline#bufname()}%m')
  else
    call airline#parts#define_raw('file', '%<%{airline#extensions#fugitiveline#bufname()}%m')
  endif
  autocmd ShellCmdPost,CmdwinLeave * unlet! b:fugitive_name
  autocmd User AirlineBeforeRefresh unlet! b:fugitive_name
endfunction
