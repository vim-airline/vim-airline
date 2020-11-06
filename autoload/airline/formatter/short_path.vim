scriptencoding utf-8

function! airline#formatter#short_path#format(val) abort
  if get(g:, 'airline_stl_path_style', 'default') ==# 'short'
    return '%{pathshorten(expand("'.a:val.'"))}'
  endif
  return a:val
endfunction
