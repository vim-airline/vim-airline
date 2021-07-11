" MIT License. Copyright (c) 2017-2021 Cimbali et al
" Plugin: https://github.com/tpope/vim-fugitive
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !airline#util#has_fugitive()
  finish
endif

function! s:ModifierFlags()
  return (exists("+autochdir") && &autochdir) ? ':p' : ':.'
endfunction

function! airline#extensions#fugitiveline#bufname() abort
  if !exists('b:fugitive_name')
    let b:fugitive_name = ''
    try
      if bufname('%') =~? '^fugitive:' && exists('*FugitiveReal')
        let b:fugitive_name = FugitiveReal(bufname('%'))
      elseif exists('b:git_dir') && exists('*fugitive#repo')
        if get(b:, 'fugitive_type', '') is# 'blob'
          let b:fugitive_name = fugitive#repo().translate(FugitivePath(@%, ''))
        endif
      elseif exists('b:git_dir') && !exists('*fugitive#repo')
        let buffer = fugitive#buffer()
        if buffer.type('blob')
          let b:fugitive_name = buffer.repo().translate(buffer.path('/'))
        endif
      endif
    catch
    endtry
  endif

  let fmod = s:ModifierFlags()
  if empty(b:fugitive_name)
    if empty(bufname('%'))
      return &buftype ==# 'nofile' ? '[Scratch]' : '[No Name]'
    endif
    return fnamemodify(bufname('%'), fmod)
  else
    return fnamemodify(b:fugitive_name, fmod). " [git]"
  endif
endfunction

function! s:sh_autocmd_handler()
  if exists('#airline')
    unlet! b:fugitive_name
  endif
endfunction

function! airline#extensions#fugitiveline#init(ext) abort
  if exists("+autochdir") && &autochdir
    " if 'acd' is set, vim-airline uses the path section, so we need to redefine this here as well
    if get(g:, 'airline_stl_path_style', 'default') ==# 'short'
      call airline#parts#define_raw('path', '%<%{pathshorten(airline#extensions#fugitiveline#bufname())}%m')
    else
      call airline#parts#define_raw('path', '%<%{airline#extensions#fugitiveline#bufname()}%m')
    endif
  else
    if get(g:, 'airline_stl_path_style', 'default') ==# 'short'
      call airline#parts#define_raw('file', '%<%{pathshorten(airline#extensions#fugitiveline#bufname())}%m')
    else
      call airline#parts#define_raw('file', '%<%{airline#extensions#fugitiveline#bufname()}%m')
    endif
  endif
  autocmd ShellCmdPost,CmdwinLeave * call s:sh_autocmd_handler()
  autocmd User AirlineBeforeRefresh call s:sh_autocmd_handler()
endfunction
