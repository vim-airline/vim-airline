" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! s:get_val(key, append)
  let part = airline#parts#get(a:key)

  let val = ''
  if exists('part.highlight')
    let val .= '%#'.(part.highlight).'#'
  endif

  if exists('part.function')
    let func = (part.function).'()'
  elseif exists('part.text')
    let func = '"'.(part.text).'"'
  elseif exists('part.raw')
    return val.(part.raw)
  else
    return a:key
  endif

  if a:append > 0
    let val .= '%{airline#util#append('.func.')}'
  elseif a:append < 0
    let val .= '%{airline#util#prepend('.func.')}'
  else
    let val .= '%{'.func.'}'
  endif
  return val
endfunction

function! airline#section#create(parts)
  return join(map(a:parts, 's:get_val(v:val, 0)'), '')
endfunction

function! airline#section#create_left(parts)
  let _ = s:get_val(a:parts[0], 0)
  for i in range(1, len(a:parts) - 1)
    let _ .= s:get_val(a:parts[i], 1)
  endfor
  return _
endfunction

function! airline#section#create_right(parts)
  let _ = ''
  for i in range(0, len(a:parts) - 2)
    let _ .= s:get_val(a:parts[i], -1)
  endfor
  let _ .= s:get_val(a:parts[-1], 0)
  return _
endfunction

