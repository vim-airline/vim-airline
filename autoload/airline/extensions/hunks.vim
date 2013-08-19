" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#hunks#get_hunks()
  let hunks = GitGutterGetHunkSummary()
  return printf('+%s ~%s -%s ', hunks[0], hunks[1], hunks[2])
endfunction

function! airline#extensions#hunks#init(ext)
  let g:airline_section_b .= '%{airline#extensions#hunks#get_hunks()}'
endfunction

