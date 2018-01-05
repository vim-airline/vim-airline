" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_signify', 0) && !get(g:, 'loaded_gitgutter', 0) && !get(g:, 'loaded_changes', 0) && !get(g:, 'loaded_quickfixsigns', 0)
  finish
endif

let s:non_zero_only = get(g:, 'airline#extensions#hunks#non_zero_only', 0)
let s:hunk_symbols = get(g:, 'airline#extensions#hunks#hunk_symbols', ['+', '~', '-'])

function! s:get_hunks_signify()
  let hunks = sy#repo#get_stats()
  if hunks[0] >= 0
    return hunks
  endif
  return []
endfunction

function! s:is_branch_empty()
  return exists('*airline#extensions#branch#head') &&
        \ empty(get(b:, 'airline_head', ''))
endfunction

function! s:get_hunks_gitgutter()
  if !get(g:, 'gitgutter_enabled', 0) || s:is_branch_empty()
    return ''
  endif
  return GitGutterGetHunkSummary()
endfunction

function! s:get_hunks_changes()
  if !get(b:, 'changes_view_enabled', 0) || s:is_branch_empty()
    return []
  endif
  let hunks = changes#GetStats()
  return hunks == [0, 0, 0] ? [] : hunks
endfunction

function! s:get_hunks_empty()
  return ''
endfunction

function! s:get_hunks()
  if !exists('b:source_func') || get(b:, 'source_func', '') is# 's:get_hunks_empty'
    if get(g:, 'loaded_signify') && sy#buffer_is_active()
      let b:source_func = 's:get_hunks_signify'
    elseif exists('*GitGutterGetHunkSummary')
      let b:source_func = 's:get_hunks_gitgutter'
    elseif exists('*changes#GetStats')
      let b:source_func = 's:get_hunks_changes'
    elseif exists('*quickfixsigns#vcsdiff#GetHunkSummary')
      let b:source_func = 'quickfixsigns#vcsdiff#GetHunkSummary'
    else
      let b:source_func = 's:get_hunks_empty'
    endif
  endif
  return {b:source_func}()
endfunction

function! airline#extensions#hunks#get_hunks()
  if !get(w:, 'airline_active', 0)
    return ''
  endif
  " Cache values, so that it isn't called too often
  if exists("b:airline_hunks") &&
    \ get(b:,  'airline_changenr', 0) == b:changedtick &&
    \ winwidth(0) == get(s:, 'airline_winwidth', 0) &&
    \ get(b:, 'source_func', '') isnot# 's:get_hunks_signify' &&
    \ get(b:, 'source_func', '') isnot# 's:get_hunks_gitgutter' &&
    \ get(b:, 'source_func', '') isnot# 's:get_hunks_empty' &&
    \ get(b:, 'source_func', '') isnot# 's:get_hunks_changes'
    return b:airline_hunks
  endif
  let hunks = s:get_hunks()
  let string = ''
  if !empty(hunks)
    for i in [0, 1, 2]
      if (s:non_zero_only == 0 && winwidth(0) > 100) || hunks[i] > 0
        let string .= printf('%s%s ', s:hunk_symbols[i], hunks[i])
      endif
    endfor
  endif
  let b:airline_hunks = string
  let b:airline_changenr = b:changedtick
  let s:airline_winwidth = winwidth(0)
  return string
endfunction

function! airline#extensions#hunks#init(ext)
  call airline#parts#define_function('hunks', 'airline#extensions#hunks#get_hunks')
endfunction
