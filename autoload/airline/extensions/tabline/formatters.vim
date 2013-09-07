" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':~:.')
let s:fnamecollapse = get(g:, 'airline#extensions#tabline#fnamecollapse', 1)
let s:buf_nr_format = get(g:, 'airline#extensions#tabline#buffer_nr_format', '%s: ')
let s:buf_nr_show = get(g:, 'airline#extensions#tabline#buffer_nr_show', 0)
let s:buf_modified_symbol = g:airline_symbols.modified

function! airline#extensions#tabline#formatters#default(bufnr, buffers)
  let _ = ''

  if s:buf_nr_show
    let _ .= printf(s:buf_nr_format, a:bufnr)
  endif

  let name = bufname(a:bufnr)
  if empty(name)
    let _ .= '[No Name]'
  else
    if s:fnamecollapse
      let _ .= substitute(fnamemodify(name, s:fmod), '\v\w\zs.{-}\ze(\\|/)', '', 'g')
    else
      let _ .= fnamemodify(name, s:fmod)
    endif
  endif

  if getbufvar(a:bufnr, '&modified') == 1
    let _ .= s:buf_modified_symbol
  endif

  return _
endfunction

