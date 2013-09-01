" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#tabline#init(ext)
  set tabline=%!airline#extensions#tabline#get()

  call a:ext.add_theme_func('airline#extensions#tabline#load_theme')
endfunction

function! airline#extensions#tabline#load_theme(palette)
  let fill = a:palette.normal.airline_c
  let normal = a:palette.normal.airline_b
  let selected = a:palette.normal.airline_a
  let type = a:palette.visual.airline_a
  call airline#highlighter#exec('airline_tabline', normal)
  call airline#highlighter#exec('airline_tablinesel', selected)
  call airline#highlighter#exec('airline_tablinetype', type)
  call airline#highlighter#exec('airline_tablinefill', fill)
endfunction

function! airline#extensions#tabline#get()
  let b = airline#builder#new({'active': 1})
  let b._line = ''

  if tabpagenr('$') == 1
    let cur = bufnr('%')
    for nr in range(1, bufnr('$'))
      if buflisted(nr) && bufexists(nr)
        if cur == nr
          call b.add_section('airline_tablinesel', '%( %{fnamemodify(bufname('.nr.'), ":t")} %)')
        else
          call b.add_section('airline_tabline', '%( %{fnamemodify(bufname('.nr.'), ":t")} %)')
        endif
      endif
    endfor
    call b.add_section('airline_tablinefill', '')
    call b.split()
    call b.add_section('airline_tablinetype', ' buffers ')
  else
    let s = ''
    for i in range(tabpagenr('$'))
      if i + 1 == tabpagenr()
        call b.add_section('airline_tablinesel', '%( %'.(i+1).'T %{airline#extensions#tabline#title('.(i+1).')} %)')
      else
        call b.add_section('airline_tabline', '%( %'.(i+1).'T %{airline#extensions#tabline#title('.(i+1).')} %)')
      endif
    endfor
    call b.add_raw('%T')
    call b.add_section('airline_tablinefill', '')
    call b.split()
    call b.add_section('airline_tabline', ' %999XX ')
    call b.add_section('airline_tablinetype', ' tabs ')
  endif
  return b.build()
endfunction

function! airline#extensions#tabline#title(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return fnamemodify(bufname(buflist[winnr - 1]), ':p:.')
endfunction

