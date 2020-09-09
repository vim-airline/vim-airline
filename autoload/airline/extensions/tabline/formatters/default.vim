" MIT License. Copyright (c) 2013-2020 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:fnamecollapse = get(g:, 'airline#extensions#tabline#fnamecollapse', 1)
let s:fnametruncate = get(g:, 'airline#extensions#tabline#fnametruncate', 0)
let s:buf_nr_format = get(g:, 'airline#extensions#tabline#buffer_nr_format', '%s: ')
let s:buf_nr_show = get(g:, 'airline#extensions#tabline#buffer_nr_show', 0)
let s:buf_modified_symbol = g:airline_symbols.modified

function! airline#extensions#tabline#formatters#default#format(bufnr, buffers)
  let fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':~:.')
  let quickfix_name = get(g:, 'airline#extensions#quickfix#quickfix_text', 'Quickfix')
  let location_name = get(g:, 'airline#extensions#quickfix#location_text', 'Location')
  let _ = ''

  if exists('*win_findbuf')
    if len(win_findbuf(a:bufnr))
      let bufwin = win_findbuf(a:bufnr)[0]
    else
      let bufwin = -1
    endif
  else
      let bufwin = bufwinid(a:bufnr)
  endif

  let name = bufname(a:bufnr)
  if empty(name)
    if getqflist({'qfbufnr' : 0}).qfbufnr == a:bufnr
      let _ .= quickfix_name
    elseif bufwin > 0 && getloclist(bufwin, {'qfbufnr' : 0}).qfbufnr == a:bufnr
      let winnr = getwininfo(bufwin)[0].winnr
      let _ .= winnr.'.'.location_name
    else
      let _ .= '[No Name]'
    endif
  elseif name =~ 'term://'
    " Neovim Terminal
    let _ = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
  else
    if s:fnamecollapse
      " Does not handle non-ascii characters like Cyrillic: 'D/Учёба/t.c'
      "let _ .= substitute(fnamemodify(name, fmod), '\v\w\zs.{-}\ze(\\|/)', '', 'g')
      let _ .= pathshorten(fnamemodify(name, fmod))
    else
      let _ .= fnamemodify(name, fmod)
    endif
    if a:bufnr != bufnr('%') && s:fnametruncate && strlen(_) > s:fnametruncate
      let _ = strpart(_, 0, s:fnametruncate)
    endif
  endif

  return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, _)
endfunction

function! airline#extensions#tabline#formatters#default#wrap_name(bufnr, buffer_name)
  let _ = s:buf_nr_show ? printf(s:buf_nr_format, a:bufnr) : ''
  let _ .= substitute(a:buffer_name, '\\', '/', 'g')

  if getbufvar(a:bufnr, '&modified') == 1
    let _ .= s:buf_modified_symbol
  endif
  return _
endfunction
