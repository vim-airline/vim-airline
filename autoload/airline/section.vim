" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

call airline#init#bootstrap()

function! s:create(parts, append)
  let _ = ''
  for idx in range(len(a:parts))
    let part = airline#parts#get(a:parts[idx])

    let val = ''
    if exists('part.highlight')
      let val .= '%#'.(part.highlight).'#'
    endif

    if exists('part.function')
      let func = (part.function).'()'
    elseif exists('part.text')
      let func = '"'.(part.text).'"'
    else
      if a:append > 0 && idx != 0
        let val .= ' '.g:airline_left_alt_sep.' '
      endif
      if a:append < 0 && idx != 0
        let val = ' '.g:airline_right_alt_sep.' '.val
      endif
      if exists('part.raw')
        let _ .= val.(part.raw)
        continue
      else
        let _ .= val.a:parts[idx]
        continue
      endif
    endif

    let minwidth = get(part, 'minwidth', 0)

    if a:append > 0 && idx != 0
      let val .= printf('%%{airline#util#append(%s,%s)}', func, minwidth)
    elseif a:append < 0 && idx != len(a:parts) - 1
      let val .= printf('%%{airline#util#prepend(%s,%s)}', func, minwidth)
    else
      let val .= printf('%%{airline#util#wrap(%s,%s)}', func, minwidth)
    endif
    let _ .= val
  endfor
  return _
endfunction

function! airline#section#create(parts)
  return s:create(a:parts, 0)
endfunction

function! airline#section#create_left(parts)
  return s:create(a:parts, 1)
endfunction

function! airline#section#create_right(parts)
  return s:create(a:parts, -1)
endfunction

