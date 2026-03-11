let g:airline#extensions#tabline#formatters#zhihu#formatter = get(g:, 'airline#extensions#tabline#formatters#zhihu#formatter', 'default')

function! airline#extensions#tabline#formatters#zhihu#format(bufnr, buffers)
  let l:name = bufname(a:bufnr)
  if match(l:name, 'zhihu://') == -1
    return airline#extensions#tabline#formatters#{g:airline#extensions#tabline#formatters#zhihu#formatter}#format(a:bufnr, a:buffers)
  endif
  let l:prefix = matchstr(fnamemodify(l:name, ':h'), '\d\+')
  if l:prefix !=# ''
    let l:prefix .= '/'
  endif
  return l:prefix . fnamemodify(l:name, ':t')
endfunction
