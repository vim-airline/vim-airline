" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':p:.')
let s:excludes = get(g:, 'airline#extensions#tabline#excludes', [])

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
  if tabpagenr('$') == 1
    return s:get_buffers()
  else
    return s:get_tabs()
  endif
endfunction

function! airline#extensions#tabline#title(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return airline#extensions#tabline#get_buffer_name(buflist[winnr - 1])
endfunction

function! airline#extensions#tabline#get_buffer_name(nr)
  let name = bufname(a:nr)
  if empty(name)
    return '[No Name]'
  endif
  return fnamemodify(name, s:fmod)
endfunction

function! s:get_buffers()
  let b = airline#builder#new({'active': 1})
  let cur = bufnr('%')
  for nr in range(1, bufnr('$'))
    if buflisted(nr) && bufexists(nr)
      for ex in s:excludes
        if match(bufname(nr), ex)
          continue
        endif
      endfor
      let group = cur == nr ? 'airline_tablinesel' : 'airline_tabline'
      call b.add_section(group, '%( %{airline#extensions#tabline#get_buffer_name('.nr.')} %)')
    endif
  endfor
  call b.add_section('airline_tablinefill', '')
  call b.split()
  call b.add_section('airline_tablinetype', ' buffers ')
  return b.build()
endfunction

function! s:get_tabs()
  let b = airline#builder#new({'active': 1})
  for i in range(1, tabpagenr('$'))
    let group = i == tabpagenr() ? 'airline_tablinesel' : 'airline_tabline'
    call b.add_section(group, ' %{len(tabpagebuflist(tabpagenr()))}%( %'.i.'T %{airline#extensions#tabline#title('.i.')} %)')
  endfor
  call b.add_raw('%T')
  call b.add_section('airline_tablinefill', '')
  call b.split()
  call b.add_section('airline_tabline', ' %999XX ')
  call b.add_section('airline_tablinetype', ' tabs ')
  return b.build()
endfunction

