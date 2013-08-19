" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#hunks#get_hunks()
  let hunks = GitGutterGetHunkSummary()
  let hunk_symbol = ['+', '~', '-']
  let string = ''
  for i in [0, 1, 2]
    if g:airline_hunk_non_zero_only == 0 || hunks[i] > 0
      let string .= printf('%s%s ', hunk_symbol[i], hunks[i])
    endif
  endfor
  return string
endfunction

function! airline#extensions#hunks#init(ext)
  let g:airline_section_b .= '%{airline#extensions#hunks#get_hunks()}'
endfunction

