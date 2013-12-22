" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':~:.')
let s:fnamecollapse = get(g:, 'airline#extensions#tabline#fnamecollapse', 1)
let s:buf_nr_format = get(g:, 'airline#extensions#tabline#buffer_nr_format', '%s: ')
let s:buf_nr_show = get(g:, 'airline#extensions#tabline#buffer_nr_show', 0)
let s:buf_modified_symbol = g:airline_symbols.modified

function! airline#extensions#tabline#formatters#default(bufnr, buffers)
  let _ = ''

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

  return s:wrap_name(a:bufnr, _)
endfunction

function! airline#extensions#tabline#formatters#unique_tail(bufnr, buffers)
  let duplicates = {}
  let tails = {}
  let map = {}
  for nr in a:buffers
    let name = bufname(nr)
    if empty(name)
      let map[nr] = '[No Name]'
    else
      let tail = fnamemodify(name, ':t')
      if has_key(tails, tail)
        let duplicates[nr] = nr
      endif
      let tails[tail] = 1
      let map[nr] = s:wrap_name(nr, tail)
    endif
  endfor

  for nr in values(duplicates)
    let map[nr] = s:wrap_name(nr, fnamemodify(bufname(nr), ':p:.'))
  endfor

  return map[a:bufnr]
endfunction

function! airline#extensions#tabline#formatters#unique_tail_improved(bufnr, buffers)
  if len(a:buffers) <= 1 " don't need to compare bufnames if has less than one buffer opened
    return airline#extensions#tabline#formatters#default(a:bufnr, a:buffers)
  endif

  let curbuf_tail = fnamemodify(bufname(a:bufnr), ':t')
  let do_deduplicate = 0
  let path_tokens = {}

  for nr in a:buffers
    let name = bufname(nr)
    if !empty(name) && nr != a:bufnr && fnamemodify(name, ':t') == curbuf_tail
      let do_deduplicate = 1
      let tokens = reverse(split(substitute(fnamemodify(name, ':p:.:h'), '\\', '/', 'g'), '/'))
      let token_index = 0
      for token in tokens
        if token == '.' | break | endif
        if !has_key(path_tokens, token_index)
          let path_tokens[token_index] = {}
        endif
        let path_tokens[token_index][token] = 1
        let token_index += 1
      endfor
    endif
  endfor

  if do_deduplicate == 1
    let path = []
    let token_index = 0
    for token in reverse(split(fnamemodify(bufname(a:bufnr), ':p:.:h'), '\'))
      if token == '.' | break | endif
      let duplicated = 0
      let uniq = 1
      let single = 1
      if has_key(path_tokens, token_index)
        let duplicated = 1
        if len(keys(path_tokens[token_index])) > 1 | let single = 0 | endif
        if has_key(path_tokens[token_index], token) | let uniq = 0 | endif
      endif
      call insert(path, {'token': token, 'duplicated': duplicated, 'uniq': uniq, 'single': single})
      let token_index += 1
    endfor

    let buf_name = [curbuf_tail]
    let has_uniq = 0
    let has_skipped = 0
    let skip_symbol = '…'
    for token1 in reverse(path)
      if !token1['duplicated'] && len(buf_name) > 1
        call insert(buf_name, skip_symbol)
        break
      endif

      if has_uniq == 1
        call insert(buf_name, skip_symbol)
        break
      endif

      if token1['uniq'] == 0 && token1['single'] == 1
        let has_skipped = 1
      else
        if has_skipped == 1
          call insert(buf_name, skip_symbol)
          let has_skipped = 0
        endif
        call insert(buf_name, token1['token'])
      endif

      if token1['uniq'] == 1
        let has_uniq = 1
      endif
    endfor
    return s:wrap_name(a:bufnr, join(buf_name, '/'))
  else
    return airline#extensions#tabline#formatters#default(a:bufnr, a:buffers)
  endif
endfunction

function! s:wrap_name(bufnr, buffer_name)
  let _ = s:buf_nr_show ? printf(s:buf_nr_format, a:bufnr) : ''
  let _ .= substitute(a:buffer_name, '\\', '/', 'g')

  if getbufvar(a:bufnr, '&modified') == 1
    let _ .= s:buf_modified_symbol
  endif
  return _
endfunction
