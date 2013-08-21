" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:non_zero_only = get(g:, 'airline#extensions#hunks#non_zero_only', 0)
let s:hunk_symbols = get(g:, 'airline#extensions#hunks#hunk_symbols', ['+', '~', '-'])

let s:initialized = 0
function! s:init()
  if !s:initialized
    let s:initialized = 1
    if get(g:, 'loaded_signify', 0)
      function! s:get_hunks()
        let hunks = sy#repo#get_stats()
        if hunks[0] >= 0
          return hunks
        endif
        return []
      endfunction
    elseif exists('*GitGutterGetHunkSummary')
      function! s:get_hunks()
        if !get(g:, 'gitgutter_enabled', 0)
          return ''
        endif
        return GitGutterGetHunkSummary()
      endfunction
    else
      function! s:get_hunks()
        return []
      endfunction
    endif
  endif
endfunction

function! airline#extensions#hunks#get_hunks()
  call <sid>init()
  let hunks = s:get_hunks()
  let string = ''
  if !empty(hunks)
    for i in [0, 1, 2]
      if s:non_zero_only == 0 || hunks[i] > 0
        let string .= printf('%s%s ', s:hunk_symbols[i], hunks[i])
      endif
    endfor
  endif
  return string
endfunction

function! airline#extensions#hunks#init(ext)
  let g:airline_section_b .= '%{airline#extensions#hunks#get_hunks()}'
endfunction

