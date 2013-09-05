" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':p:.')
let s:excludes = get(g:, 'airline#extensions#tabline#excludes', [])
let s:tab_nr_type = get(g:, 'airline#extensions#tabline#tab_nr_type', 0)
let s:show_buffers = get(g:, 'airline#extensions#tabline#show_buffers', 1)
let s:buf_nr_show = get(g:, 'airline#extensions#tabline#buffer_nr_show', 0)
let s:buf_nr_format = get(g:, 'airline#extensions#tabline#buffer_nr_format', '%s: ')
let s:buf_modified_symbol = g:airline_symbols.modified

let s:builder_context = {
      \ 'active'        : 1,
      \ 'left_sep'      : get(g:, 'airline#extensions#tabline#left_sep'     , g:airline_left_sep),
      \ 'left_alt_sep'  : get(g:, 'airline#extensions#tabline#left_alt_sep' , g:airline_left_alt_sep),
      \ 'right_sep'     : get(g:, 'airline#extensions#tabline#right_sep'    , g:airline_right_sep),
      \ 'right_alt_sep' : get(g:, 'airline#extensions#tabline#right_alt_sep', g:airline_right_alt_sep),
      \ }

let s:buf_min_count = get(g:, 'airline#extensions#tabline#buffer_min_count', 0)
let s:buf_len = 0

function! airline#extensions#tabline#init(ext)
  if has('gui_running')
    set guioptions-=e
  endif

  set tabline=%!airline#extensions#tabline#get()

  if s:buf_min_count <= 0
    set showtabline=2
  else
    autocmd CursorMoved * call <sid>cursormove()
  endif

  call a:ext.add_theme_func('airline#extensions#tabline#load_theme')
endfunction

function! airline#extensions#tabline#load_theme(palette)
  let colors    = get(a:palette, 'tabline', {})
  let l:tab     = get(colors, 'airline_tab', a:palette.normal.airline_b)
  let l:tabsel  = get(colors, 'airline_tabsel', a:palette.normal.airline_a)
  let l:tabtype = get(colors, 'airline_tabtype', a:palette.visual.airline_a)
  let l:tabfill = get(colors, 'airline_tabfill', a:palette.normal.airline_c)
  let l:tabmod  = get(colors, 'airline_tabmod', a:palette.insert.airline_a)
  call airline#highlighter#exec('airline_tab', l:tab)
  call airline#highlighter#exec('airline_tabsel', l:tabsel)
  call airline#highlighter#exec('airline_tabtype', l:tabtype)
  call airline#highlighter#exec('airline_tabfill', l:tabfill)
  call airline#highlighter#exec('airline_tabmod', l:tabmod)
endfunction

function! s:cursormove()
  let c = len(s:get_buffer_list())
  if c > s:buf_min_count
    if &showtabline != 2
      set showtabline=2
    endif
  else
    if &showtabline != 0
      set showtabline=0
    endif
  endif
endfunction

function! airline#extensions#tabline#get()
  if s:show_buffers && tabpagenr('$') == 1
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
  let _ = ''
  let name = bufname(a:nr)

  if s:buf_nr_show
    let _ .= printf(s:buf_nr_format, a:nr)
  endif

  if empty(name)
    let _ .= '[No Name]'
  else
    let _ .= fnamemodify(name, s:fmod)
  endif

  if getbufvar(a:nr, '&modified') == 1
    let _ .= s:buf_modified_symbol
  endif

  return _
endfunction

function! s:get_buffer_list()
  let buffers = []
  let cur = bufnr('%')
  for nr in range(1, bufnr('$'))
    if buflisted(nr) && bufexists(nr)
      for ex in s:excludes
        if match(bufname(nr), ex)
          continue
        endif
      endfor
      call add(buffers, nr)
    endif
  endfor
  return buffers
endfunction

function! s:get_buffers()
  let b = airline#builder#new(s:builder_context)
  let cur = bufnr('%')
  for nr in s:get_buffer_list()
    if cur == nr
      if g:airline_detect_modified && getbufvar(nr, '&modified')
        let group = 'airline_tabmod'
      else
        let group = 'airline_tabsel'
      endif
    else
      let group = 'airline_tab'
    endif
    call b.add_section(group, '%( %{airline#extensions#tabline#get_buffer_name('.nr.')} %)')
  endfor

  call b.add_section('airline_tabfill', '')
  call b.split()
  call b.add_section('airline_tabtype', ' buffers ')
  return b.build()
endfunction

function! s:get_tabs()
  let b = airline#builder#new(s:builder_context)
  for i in range(1, tabpagenr('$'))
    if i == tabpagenr()
      let group = 'airline_tabsel'
      if g:airline_detect_modified
        for bi in tabpagebuflist(i)
          if getbufvar(bi, '&modified')
            let group = 'airline_tabmod'
          endif
        endfor
      endif
    else
      let group = 'airline_tab'
    endif
    let val = '%('
    if s:tab_nr_type == 0
      let val .= ' %{len(tabpagebuflist('.i.'))}'
    else
      let val .= ' '.i
    endif
    call b.add_section(group, val.'%'.i.'T %{airline#extensions#tabline#title('.i.')} %)')
  endfor
  call b.add_raw('%T')
  call b.add_section('airline_tabfill', '')
  call b.split()
  call b.add_section('airline_tab', ' %999XX ')
  call b.add_section('airline_tabtype', ' tabs ')
  return b.build()
endfunction

