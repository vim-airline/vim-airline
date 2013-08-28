" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! s:get_val(part)
  let val = g:airline_parts[a:part]
  if match(val, '%') > -1
    return val
  else
    return '%{function("'.val.'")()}'
  endif
endfunction

function! airline#util#define_section(key, parts)
  if !exists('g:airline_section_{a:key}') && len(a:parts) > 0
    let g:airline_section_{a:key} = s:get_val(a:parts[0])
    for i in range(1, len(a:parts) - 1)
      let g:airline_section_{a:key} .= s:get_val(a:parts[i])
    endfor
  endif
endfunction

if v:version >= 704
  function! airline#util#getwinvar(winnr, key, def)
    return getwinvar(a:winnr, a:key, a:def)
  endfunction
else
  function! airline#util#getwinvar(winnr, key, def)
    let winvals = getwinvar(a:winnr, '')
    return get(winvals, a:key, a:def)
  endfunction
endif

if v:version >= 704
  function! airline#util#exec_funcrefs(list, ...)
    for Fn in a:list
      let code = call(Fn, a:000)
      if code != 0
        return code
      endif
    endfor
    return 0
  endfunction
else
  function! airline#util#exec_funcrefs(list, ...)
    " for 7.2; we cannot iterate the list, hence why we use range()
    " for 7.3-[97, 328]; we cannot reuse the variable, hence the {}
    for i in range(0, len(a:list) - 1)
      let Fn{i} = a:list[i]
      let code = call(Fn{i}, a:000)
      if code != 0
        return code
      endif
    endfor
    return 0
  endfunction
endif

