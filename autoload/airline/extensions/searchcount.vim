" MIT License. Copyright (c) 2013-2020 Bailey Ling et al.
" This extension is inspired by vim-anzu <https://github.com/osyo-manga/vim-anzu>.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8


function! airline#extensions#searchcount#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#searchcount#apply')
endfunction

function! airline#extensions#searchcount#apply(...) abort
  call airline#extensions#append_to_section('y', 
        \ '%{v:hlsearch ? airline#extensions#searchcount#status() : ""}')
endfunction

function! airline#extensions#searchcount#status() abort
  let result = searchcount(#{recompute: 1})
  if empty(result) || result.total ==# 0
    return ''
  endif
  if result.incomplete ==# 1     " timed out
    return printf(' /%s [?/??]', @/)
  elseif result.incomplete ==# 2 " max count exceeded
    if result.total > result.maxcount &&
          \  result.current > result.maxcount
      return printf('%s[>%d/>%d]', @/,
            \		    result.current, result.total)
    elseif result.total > result.maxcount
      return printf('%s[%d/>%d]', @/,
            \		    result.current, result.total)
    endif
  endif
  return printf('%s[%d/%d]', @/,
        \		result.current, result.total)
endfunction

autocmd CursorMoved *
      \ let s:searchcount_timer = timer_start(
      \   10, function('s:update_searchcount'))

function! s:update_searchcount(timer) abort
  if a:timer ==# s:searchcount_timer
    call searchcount(#{
          \ recompute: 1, maxcount: 0, timeout: 100})
  endif
endfunction
