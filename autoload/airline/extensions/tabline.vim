" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#tabline#init(ext)
  set tabline=%!airline#extensions#tabline#get()
endfunction

function! airline#extensions#tabline#get()
  let b = airline#builder#new({'active': 1})
  let b._line = ''

  if tabpagenr('$') == 1
    let cur = bufnr('%')
    for nr in range(1, bufnr('$'))
      if buflisted(nr) && bufexists(nr)
        if cur == nr
          call b.add_section('TabLineSel', '%( %{fnamemodify(bufname('.nr.'), ":t")} %)')
        else
          call b.add_section('TabLine', '%( %{fnamemodify(bufname('.nr.'), ":t")} %)')
        endif
      endif
    endfor
    call b.add_section('TabLineFill', '')
    call b.split()
    call b.add_section('TabLineSel', ' buffers ')
  else
    let s = ''
    for i in range(tabpagenr('$'))
      if i + 1 == tabpagenr()
        call b.add_section('TabLineSel', '%( %'.(i+1).'T %{airline#extensions#tabline#title('.(i+1).')} %)')
      else
        call b.add_section('TabLine', '%( %'.(i+1).'T %{airline#extensions#tabline#title('.(i+1).')} %)')
      endif
    endfor
    call b.add_raw('%T')
    call b.add_section('TabLineFill', '')
    call b.split()
    call b.add_section('TabLine', ' %999XX ')
    call b.add_section('TabLineSel', ' tabs ')
  endif
  return b.build()
endfunction

function! airline#extensions#tabline#title(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return fnamemodify(bufname(buflist[winnr - 1]), ':p:.')
endfunction

