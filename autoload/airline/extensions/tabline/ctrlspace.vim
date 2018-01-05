" MIT License. Copyright (c) 2016-2018 Kevin Sapper et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:current_bufnr = -1
let s:current_tabnr = -1
let s:current_tabline = ''

function! airline#extensions#tabline#ctrlspace#off()
  augroup airline_tabline_ctrlspace
    autocmd!
  augroup END
endfunction

function! airline#extensions#tabline#ctrlspace#on()
  augroup airline_tabline_ctrlspace
    autocmd!
    autocmd BufDelete * call airline#extensions#tabline#ctrlspace#invalidate()
  augroup END
endfunction

function! airline#extensions#tabline#ctrlspace#invalidate()
  let s:current_bufnr = -1
  let s:current_tabnr = -1
endfunction

function! airline#extensions#tabline#ctrlspace#add_buffer_section(builder, cur_tab, cur_buf, pos)
  if a:pos == 0
    let pos_extension = ''
  else
    let pos_extension = '_right'
  endif

  let s:buffer_list = ctrlspace#api#BufferList(a:cur_tab)
  " add by tenfy(tenfyzhong@qq.com)
  " if the current buffer no in the buffer list
  " return false and no redraw tabline. 
  " Fixes #1515. if there a BufEnter autocmd execute redraw. The tabline may no update.
  let bufnr_list = map(copy(s:buffer_list), 'v:val["index"]')
  if index(bufnr_list, a:cur_buf) == -1
    return 0
  endif

  for buffer in s:buffer_list
      if a:cur_buf == buffer.index
        if buffer.modified
          let group = 'airline_tabmod'.pos_extension
        else
          let group = 'airline_tabsel'.pos_extension
        endif
      else
        if buffer.modified
          let group = 'airline_tabmod_unsel'.pos_extension
        elseif buffer.visible
          let group = 'airline_tab'.pos_extension
        else
          let group = 'airline_tabhid'.pos_extension
        endif
      endif

      let buf_name = '%(%{airline#extensions#tabline#get_buffer_name('.buffer.index.')}%)'

      if has("tablineat")
        let buf_name = '%'.buffer.index.'@airline#extensions#tabline#buffers#clickbuf@'.buf_name.'%X'
      endif

      call a:builder.add_section_spaced(group, buf_name)
  endfor
  " add by tenfy(tenfyzhong@qq.com)
  " if the selected buffer was updated
  " return true
  return 1
endfunction

function! airline#extensions#tabline#ctrlspace#add_tab_section(builder, pos)
  if a:pos == 0
    let pos_extension = ''
  else
    let pos_extension = '_right'
  endif

  for tab in s:tab_list
    if tab.current
      if tab.modified
        let group = 'airline_tabmod'.pos_extension
      else
        let group = 'airline_tabsel'.pos_extension
      endif
    else
      if tab.modified
        let group = 'airline_tabmod_unsel'.pos_extension
      else
        let group = 'airline_tabhid'.pos_extension
      endif
    endif

    call a:builder.add_section_spaced(group, '%'.tab.index.'T'.tab.title.ctrlspace#api#TabBuffersNumber(tab.index).'%T')
  endfor
endfunction

function! airline#extensions#tabline#ctrlspace#get()
  let cur_buf = bufnr('%')
  let buffer_label = get(g:, 'airline#extensions#tabline#buffers_label', 'buffers')
  let tab_label = get(g:, 'airline#extensions#tabline#tabs_label', 'tabs')
  let switch_buffers_and_tabs = get(g:, 'airline#extensions#tabline#switch_buffers_and_tabs', 0)

  try
    call airline#extensions#tabline#tabs#map_keys()
  catch
    " no-op
  endtry
  let s:tab_list = ctrlspace#api#TabList()
  for tab in s:tab_list
    if tab.current
      let cur_tab = tab.index
    endif
  endfor

  if cur_buf == s:current_bufnr && cur_tab == s:current_tabnr
    return s:current_tabline
  endif

  let builder = airline#extensions#tabline#new_builder()

  " Add left tabline content
  if get(g:, 'airline#extensions#tabline#show_buffers', 1) == 0
      call airline#extensions#tabline#ctrlspace#add_tab_section(builder, 0)
  elseif get(g:, 'airline#extensions#tabline#show_tabs', 1) == 0
      " add by tenfy(tenfyzhong@qq.com)
      " if current buffer no in the buffer list, does't update tabline
      if airline#extensions#tabline#ctrlspace#add_buffer_section(builder, cur_tab, cur_buf, 0) == 0
        return s:current_tabline
      endif
  else
    if switch_buffers_and_tabs == 0
      call builder.add_section_spaced('airline_tabtype', buffer_label)
      " add by tenfy(tenfyzhong@qq.com)
      " if current buffer no in the buffer list, does't update tabline
      if airline#extensions#tabline#ctrlspace#add_buffer_section(builder, cur_tab, cur_buf, 0) == 0
        return s:current_tabline
      endif
    else
      call builder.add_section_spaced('airline_tabtype', tab_label)
      call airline#extensions#tabline#ctrlspace#add_tab_section(builder, 0)
    endif
  endif

  call builder.add_section('airline_tabfill', '')
  call builder.split()
  call builder.add_section('airline_tabfill', '')

  " Add right tabline content
  if get(g:, 'airline#extensions#tabline#show_buffers', 1) == 0
      call builder.add_section_spaced('airline_tabtype', tab_label)
  elseif get(g:, 'airline#extensions#tabline#show_tabs', 1) == 0
      call builder.add_section_spaced('airline_tabtype', buffer_label)
  else
    if switch_buffers_and_tabs == 0
      call airline#extensions#tabline#ctrlspace#add_tab_section(builder, 1)
      call builder.add_section_spaced('airline_tabtype', tab_label)
    else
      " add by tenfy(tenfyzhong@qq.com)
      " if current buffer no in the buffer list, does't update tabline
      if airline#extensions#tabline#ctrlspace#add_buffer_section(builder, cur_tab, cur_buf, 1) == 0
        return s:current_tabline
      endif
      call builder.add_section_spaced('airline_tabtype', buffer_label)
    endif
  endif

  let s:current_bufnr = cur_buf
  let s:current_tabnr = cur_tab
  let s:current_tabline = builder.build()
  return s:current_tabline
endfunction
