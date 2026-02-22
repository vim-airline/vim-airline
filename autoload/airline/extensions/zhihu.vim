" MIT License. Copyright (c) 2026-2026 Wu Zhenyu et al
" Plugin: https://github.com/pxwg/zhihu.nvim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !airline#util#has_zhihu()
  finish
endif

let s:has_percent_eval = v:version > 802 || (v:version == 802 && has("patch2854"))

function! airline#extensions#zhihu#bufname() abort
  let fmod = (exists("+autochdir") && &autochdir) ? ':p' : ':.'
  let name = fnamemodify(bufname('%'), fmod)

  if empty(name)
    return ''
  endif

  if match(name, '^zhihu://') == -1
    return s:has_percent_eval ? '%f' : name
  endif

  return get(get(b:, 'article', {}), 'title', name)
endfunction

function! airline#extensions#zhihu#init(ext) abort
  let prct = s:has_percent_eval ? '%' : ''

  if exists("+autochdir") && &autochdir
    " if 'acd' is set, vim-airline uses the path section, so we need to redefine this here as well
    if get(g:, 'airline_stl_path_style', 'default') ==# 'short'
      call airline#parts#define_raw('path', '%<%{'. prct. 'pathshorten(airline#extensions#zhihu#bufname())' . prct . '}%m')
    else
      call airline#parts#define_raw('path', '%<%{' . prct . 'airline#extensions#zhihu#bufname()' . prct . '}%m')
    endif
  else
    if get(g:, 'airline_stl_path_style', 'default') ==# 'short'
      call airline#parts#define_raw('file', '%<%{' . prct . 'pathshorten(airline#extensions#zhihu#bufname())' . prct . '}%m')
    else
      call airline#parts#define_raw('file', '%<%{' . prct . 'airline#extensions#zhihu#bufname()' . prct . '}%m')
    endif
  endif
endfunction
