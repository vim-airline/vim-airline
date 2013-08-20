" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:non_zero_only = get(g:, 'airline#extensions#hunks#non_zero_only', 0)
let s:hunk_symbols = get(g:, 'airline#extensions#hunks#hunk_symbols', ['+', '~', '-'])

function! airline#extensions#hunks#get_hunks()
  let hunks = GitGutterGetHunkSummary()
  let string = ''
  for i in [0, 1, 2]
    if s:non_zero_only == 0 || hunks[i] > 0
      let string .= printf('%s%s ', s:hunk_symbols[i], hunks[i])
    endif
  endfor
  return string
endfunction

function! airline#extensions#hunks#init(ext)
  let g:airline_section_b .= '%{airline#extensions#hunks#get_hunks()}'
endfunction

