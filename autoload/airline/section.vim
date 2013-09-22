" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

call airline#init#bootstrap()
let s:spc = g:airline_symbols.space

function! s:create(parts, append)
  let _ = ''
  for idx in range(len(a:parts))
    let part = airline#parts#get(a:parts[idx])

    let val = ''
    if exists('part.accent')
      let val .= '%#__accent_'.(part.accent).'#'
    endif

    if exists('part.function')
      let func = (part.function).'()'
    elseif exists('part.text')
      let func = '"'.(part.text).'"'
    else
      if a:append > 0 && idx != 0
        let val .= s:spc.g:airline_left_alt_sep.s:spc
      endif
      if a:append < 0 && idx != 0
        let val = s:spc.g:airline_right_alt_sep.s:spc.val
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
      let partval = printf('%%{airline#util#append(%s,%s)}', func, minwidth)
    elseif a:append < 0 && idx != len(a:parts) - 1
      let partval = printf('%%{airline#util#prepend(%s,%s)}', func, minwidth)
    else
      let partval = printf('%%{airline#util#wrap(%s,%s)}', func, minwidth)
    endif

    if exists('part.condition')
      let partval = substitute(partval, '{', '{'.(part.condition).' ? ', '')
      let partval = substitute(partval, '}', ' : ""}', '')
    endif

    let val .= partval
    if exists('part.accent')
      let val .= '%#__restore__#'
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

