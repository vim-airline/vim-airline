let g:airline#extensions#tabline#formatters#nerdfont#formatter = get(g:, 'airline#extensions#tabline#formatters#nerdfont#formatter', 'default')

function! airline#extensions#tabline#formatters#nerdfont#format(bufnr, buffers) abort
  " Call original formatter.
  let originalFormatter = airline#extensions#tabline#formatters#{g:airline#extensions#tabline#formatters#nerdfont#formatter}#format(a:bufnr, a:buffers)
  return originalFormatter . printf(' %s', nerdfont#find(bufname(a:bufnr)))
endfunction
