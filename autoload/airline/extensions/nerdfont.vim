" MIT License. Copyright (c) 2026-2026 Wu Zhenyu et al
" Plugin: https://github.com/lambdalisue/nerdfont.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_nerdfont', 0)
  finish
endif

function! airline#extensions#nerdfont#fileformat() abort
  if &fileformat ==# 'dos'
    return nerdfont#platform#find('windows')
  endif
  if &fileformat ==# 'mac'
    return nerdfont#platform#find('macos')
  endif
  if &fileformat ==# 'unix'
    if has('unix')
      return nerdfont#platform#find()
    else
      return nerdfont#platform#find('linux')
    endif
  endif
endfunction

function! airline#extensions#nerdfont#ffenc() abort
  let expected = get(g:, 'airline#parts#ffenc#skip_expected_string', '')
  let bomb     = &bomb ? '[BOM]' : ''
  let noeolf   = &eol ? '' : '[!EOL]'
  let ff       = strlen(&ff) ? '['.&ff.']' : ''
  if expected is# &fenc.bomb.noeolf.ff
    return ''
  else
    return &fenc.bomb.noeolf.' '.airline#extensions#nerdfont#fileformat()
  endif
endfunction

function! airline#extensions#nerdfont#init(ext) abort
  call airline#parts#define_function('ffenc', 'airline#extensions#nerdfont#ffenc')
  call a:ext.add_statusline_func('airline#extensions#nerdfont#apply')
endfunction

function! airline#extensions#nerdfont#apply(...) abort
  call airline#extensions#append_to_section('x', ' %{nerdfont#find()}')
endfunction
