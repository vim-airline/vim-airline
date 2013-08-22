" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

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

