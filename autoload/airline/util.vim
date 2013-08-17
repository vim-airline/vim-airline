" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

" for 7.2 compatibility
function! airline#util#getwinvar(winnr, key, ...)
  let winvals = getwinvar(a:winnr, '')
  return get(winvals, a:key, (a:0 ? a:1 : ''))
endfunction

function! airline#util#exec_funcrefs(list, break_early)
  " for 7.2; we cannot iterate list, hence why we use range()
  " for 7.3-[97, 328]; we cannot reuse the variable, hence the {}
  for i in range(0, len(a:list) - 1)
    let Fn{i} = a:list[i]
    if a:break_early
      if Fn{i}()
        return 1
      endif
    else
      call Fn{i}()
    endif
  endfor
  return 0
endfunction

