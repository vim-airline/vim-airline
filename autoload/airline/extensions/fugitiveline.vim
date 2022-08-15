" MIT License. Copyright (c) 2017-2021 Cimbali et al
" Plugin: https://github.com/tpope/vim-fugitive
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !airline#util#has_fugitive()
  finish
endif

let s:has_percent_eval = v:version > 802 || (v:version == 802 && has("patch2854"))

function! airline#extensions#fugitiveline#bufname() abort
  if !exists('b:fugitive_name')
    let b:fugitive_name = ''
    try
      if bufname('%') =~? '^fugitive:' && exists('*FugitiveReal')
        let b:fugitive_name = FugitiveReal(bufname('%'))
      endif
    catch
    endtry
  endif

  let fmod = (exists("+autochdir") && &autochdir) ? ':p' : ':.'
  let result=''
  if empty(b:fugitive_name)
    if empty(bufname('%'))
      return &buftype ==# 'nofile' ? '[Scratch]' : '[No Name]'
    endif
    return s:has_percent_eval ? '%f' : fnamemodify(bufname('%'), fmod)
  else
    return s:has_percent_eval ? '%f [git]' : (fnamemodify(b:fugitive_name, fmod). " [git]")
  endif
endfunction

function! s:sh_autocmd_handler()
  if exists('#airline')
    unlet! b:fugitive_name
  endif
endfunction

function! airline#extensions#fugitiveline#init(ext) abort
  let prct = s:has_percent_eval ? '%' : ''

  if exists("+autochdir") && &autochdir
    " if 'acd' is set, vim-airline uses the path section, so we need to redefine this here as well
    if get(g:, 'airline_stl_path_style', 'default') ==# 'short'
      call airline#parts#define_raw('path', '%<%{'. prct. 'pathshorten(airline#extensions#fugitiveline#bufname())' . prct . '}%m')
    else
      call airline#parts#define_raw('path', '%<%{' . prct . 'airline#extensions#fugitiveline#bufname()' . prct . '}%m')
    endif
  else
    if get(g:, 'airline_stl_path_style', 'default') ==# 'short'
      call airline#parts#define_raw('file', '%<%{' . prct . 'pathshorten(airline#extensions#fugitiveline#bufname())' . prct . '}%m')
    else
      call airline#parts#define_raw('file', '%<%{' . prct . 'airline#extensions#fugitiveline#bufname()' . prct . '}%m')
    endif
  endif
  autocmd ShellCmdPost,CmdwinLeave * call s:sh_autocmd_handler()
  autocmd User AirlineBeforeRefresh call s:sh_autocmd_handler()
endfunction
