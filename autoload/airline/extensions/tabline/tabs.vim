" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:spc = g:airline_symbols.space
let s:current_bufnr = -1
let s:current_tabnr = -1
let s:current_modified = 0

function! airline#extensions#tabline#tabs#off()
  augroup airline_tabline_tabs
    autocmd!
  augroup END
endfunction

function! airline#extensions#tabline#tabs#on()
  augroup airline_tabline_tabs
    autocmd!
    autocmd BufDelete * call airline#extensions#tabline#tabs#invalidate()
  augroup END
endfunction

function! airline#extensions#tabline#tabs#invalidate()
  let s:current_bufnr = -1
endfunction

function! s:get_visible_tabs(width)
  let tablist = range(1, tabpagenr('$'))
  let curbuf = bufnr('%')

  if get(g:, 'airline#extensions#tabline#current_first', 0)
    " always have current tabpage first
    if index(tablist, curtab) > -1
      call remove(tablist, index(tablist, curtab))
    endif
    let tablist = [curtab] + tablist
  endif

  let total_width = 0
  let max_width = 0

  for nr in tablist
    let width = len(airline#extensions#tabline#title(nr)) + 4
    let total_width += width
    let max_width = max([max_width, width])
  endfor

  " only show current and surrounding tabs if there are too many tabs
  let position  = index(tablist, curbuf)
  if total_width > a:width && position > -1
    let tab_count = len(tablist)

    " determine how many tabs to show based on the longest tab width,
    " use one on the right side and put the rest on the left
    let tab_max   = a:width / max_width
    let tab_right = 1
    let tab_left  = max([0, tab_max - tab_right])

    let start = max([0, position - tab_left])
    let end   = min([tab_count, position + tab_right])

    " fill up available space on the right
    if position < tab_left
      let end += (tab_left - position)
    endif

    " fill up available space on the left
    if end > tab_count - 1 - tab_right
      let start -= max([0, tab_right - (tab_count - 1 - position)])
    endif

    let tablist = eval('tablist[' . start . ':' . end . ']')

    if start > 0
      call insert(tablist, -1, 0)
    endif

    if end < tab_count - 1
      call add(tablist, -1)
    endif
  endif

  return tablist
endfunction

function! airline#extensions#tabline#tabs#get()
  let curbuf = bufnr('%')
  let curtab = tabpagenr()
  try
    call airline#extensions#tabline#tabs#map_keys()
  catch
    " no-op
  endtry
  if curbuf == s:current_bufnr && curtab == s:current_tabnr
    if !g:airline_detect_modified || getbufvar(curbuf, '&modified') == s:current_modified
      return s:current_tabline
    endif
  endif

  let tab_nr_type = get(g:, 'airline#extensions#tabline#tab_nr_type', 0)
  let b = airline#extensions#tabline#new_builder()

  call airline#extensions#tabline#add_label(b, 'tabs')

  let tabs_position = b.get_position()

  call b.add_section('airline_tabfill', '')
  call b.split()
  call b.add_section('airline_tabfill', '')

  if get(g:, 'airline#extensions#tabline#show_close_button', 1)
    call b.add_section('airline_tab_right', ' %999X'.
          \ get(g:, 'airline#extensions#tabline#close_symbol', 'X').' ')
  endif

  if get(g:, 'airline#extensions#tabline#show_splits', 1) == 1
    let buffers = tabpagebuflist(curtab)
    for nr in buffers
      let group = airline#extensions#tabline#group_of_bufnr(buffers, nr) . "_right"
      call b.add_section_spaced(group, '%(%{airline#extensions#tabline#get_buffer_name('.nr.')}%)')
    endfor
    call airline#extensions#tabline#add_label(b, 'buffers')
  endif

  for i in s:get_visible_tabs(&columns)
    if i < 0
      call b.insert_raw('%#airline_tab#...', tabs_position)
      let tabs_position += 1
      continue
    endif
    if i == curtab
      let group = 'airline_tabsel'
      if g:airline_detect_modified
        for bi in tabpagebuflist(i)
          if getbufvar(bi, '&modified')
            let group = 'airline_tabmod'
          endif
        endfor
      endif
      let s:current_modified = (group == 'airline_tabmod') ? 1 : 0
    else
      let group = 'airline_tab'
    endif
    let val = '%('

    if get(g:, 'airline#extensions#tabline#show_tab_nr', 1)
      let val .= airline#extensions#tabline#tabs#tabnr_formatter(tab_nr_type, i)
    endif
    call b.insert_section(group, val.'%'.i.'T %{airline#extensions#tabline#title('.i.')} %)', tabs_position)
    let tabs_position += 1
  endfor

  let s:current_bufnr = curbuf
  let s:current_tabnr = curtab
  let s:current_tabline = b.build()
  return s:current_tabline
endfunction

function! airline#extensions#tabline#tabs#map_keys()
  if exists("s:airline_tabline_map_key")
    return
  endif
  noremap <silent> <Plug>AirlineSelectTab1 :1tabn<CR>
  noremap <silent> <Plug>AirlineSelectTab2 :2tabn<CR>
  noremap <silent> <Plug>AirlineSelectTab3 :3tabn<CR>
  noremap <silent> <Plug>AirlineSelectTab4 :4tabn<CR>
  noremap <silent> <Plug>AirlineSelectTab5 :5tabn<CR>
  noremap <silent> <Plug>AirlineSelectTab6 :6tabn<CR>
  noremap <silent> <Plug>AirlineSelectTab7 :7tabn<CR>
  noremap <silent> <Plug>AirlineSelectTab8 :8tabn<CR>
  noremap <silent> <Plug>AirlineSelectTab9 :9tabn<CR>
  noremap <silent> <Plug>AirlineSelectPrevTab gT
  " tabn {count} goes to count tab does not go {count} tab pages forward!
  noremap <silent> <Plug>AirlineSelectNextTab :<C-U>exe repeat(':tabn\|', v:count1)<cr>
  let s:airline_tabline_map_key = 1
endfunction

function! airline#extensions#tabline#tabs#tabnr_formatter(nr, i)
  let formatter = get(g:, 'airline#extensions#tabline#tabnr_formatter', 'tabnr')
  return airline#extensions#tabline#formatters#{formatter}#format(a:nr, a:i)
endfunction
