" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#debug#profile()
  profile start airline-profile.log
  profile func *
  profile file *
  split
  for i in range(1, 1000)
    wincmd w
    redrawstatus
  endfor
  profile pause
  noautocmd qall!
endfunction
