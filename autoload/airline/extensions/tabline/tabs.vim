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
  " always have current tabpage first
  let tablist = range(1, tabpagenr('$'))
  if get(g:, 'airline#extensions#tabline#current_first', 0)
    if index(tablist, curtab) > -1
      call remove(tablist, index(tablist, curtab))
    endif
    let tablist = [curtab] + tablist
  endif
  for i in tablist
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
    call b.add_section(group, val.'%'.i.'T %{airline#extensions#tabline#title('.i.')} %)')
  endfor

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
