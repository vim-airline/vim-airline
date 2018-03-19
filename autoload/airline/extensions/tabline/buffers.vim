" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:current_bufnr = -1
let s:current_modified = 0
let s:current_tabline = ''
let s:current_visible_buffers = []

let s:number_map = {
      \ '0': '⁰',
      \ '1': '¹',
      \ '2': '²',
      \ '3': '³',
      \ '4': '⁴',
      \ '5': '⁵',
      \ '6': '⁶',
      \ '7': '⁷',
      \ '8': '⁸',
      \ '9': '⁹'
      \ }
let s:number_map = &encoding == 'utf-8'
      \ ? get(g:, 'airline#extensions#tabline#buffer_idx_format', s:number_map)
      \ : {}

function! airline#extensions#tabline#buffers#off()
  augroup airline_tabline_buffers
    autocmd!
  augroup END
endfunction

function! airline#extensions#tabline#buffers#on()
  augroup airline_tabline_buffers
    autocmd!
    autocmd BufDelete * call airline#extensions#tabline#buffers#invalidate()
    autocmd User BufMRUChange call airline#extensions#tabline#buflist#invalidate()
    autocmd User BufMRUChange call airline#extensions#tabline#buffers#invalidate()
  augroup END
endfunction

function! airline#extensions#tabline#buffers#invalidate()
  let s:current_bufnr = -1
endfunction

function! airline#extensions#tabline#buffers#get()
  try
    call <sid>map_keys()
  catch
    " no-op
  endtry
  let cur = bufnr('%')
  if cur == s:current_bufnr
    if !g:airline_detect_modified || getbufvar(cur, '&modified') == s:current_modified
      return s:current_tabline
    endif
  endif

  let index = 1
  let b = airline#extensions#tabline#new_builder()
  let tab_bufs = tabpagebuflist(tabpagenr())
  let show_buf_label_first = 0

  if get(g:, 'airline#extensions#tabline#buf_label_first', 0)
    let show_buf_label_first = 1
  endif

  let spc = get(g:, 'airline#extensions#tabline#spaces_around_buffer_name', 1) ? g:airline_symbols.space : ''
  let ellipsis = get(g:, 'airline#extensions#tabline#ellipsis', '...')

  if show_buf_label_first
    call airline#extensions#tabline#add_label(b, 'buffers')
  endif
  let pgroup = ''
  for nr in s:get_visible_buffers()
    if nr < 0
      call b.add_section('airline_tabhid', ellipsis)
      continue
    endif

    let group = airline#extensions#tabline#group_of_bufnr(tab_bufs, nr)

    if nr == cur
      let s:current_modified = (group == 'airline_tabmod') ? 1 : 0
    endif

    " Neovim feature: Have clickable buffers
    if has("tablineat")
      call b.add_raw('%'.nr.'@airline#extensions#tabline#buffers#clickbuf@')
    endif

    if get(g:, 'airline_powerline_fonts', 0)
      let space = spc
    else
      let space= (pgroup == group ? spc : '')
    endif

    if get(g:, 'airline#extensions#tabline#buffer_idx_mode', 0)
      if len(s:number_map) > 0
        call b.add_section(group, space. get(s:number_map, index, '') . '%(%{airline#extensions#tabline#get_buffer_name('.nr.')}%)' . spc)
      else
        call b.add_section(group, '['.index.spc.'%(%{airline#extensions#tabline#get_buffer_name('.nr.')}%)'.']')
      endif
      let index += 1
    else
      call b.add_section(group, space.'%(%{airline#extensions#tabline#get_buffer_name('.nr.')}%)'.spc)
    endif

    if has("tablineat")
      call b.add_raw('%X')
    endif
    let pgroup=group
  endfor

  call b.add_section('airline_tabfill', '')
  call b.split()
  call b.add_section('airline_tabfill', '')
  if !show_buf_label_first
    call airline#extensions#tabline#add_label(b, 'buffers')
  endif

  if tabpagenr('$') > 1
    call b.add_section_spaced('airline_tabmod', printf('%s %d/%d', "tab", tabpagenr(), tabpagenr('$')))
  endif

  let s:current_bufnr = cur
  let s:current_tabline = b.build()
  return s:current_tabline
endfunction

" Compatibility wrapper for strchars, in case current vim version does not have it natively
function! s:strchars(str)
  if exists('*strchars')
    return strchars(a:str)
  else
    return strlen(substitute(a:str, '.', 'a', 'g'))
  endif
endfunction

function! s:get_visible_buffers()
  let buffers = airline#extensions#tabline#buflist#list()
  let cur = bufnr('%')
  if get(g:, 'airline#extensions#tabline#current_first', 0)
    if index(buffers, cur) > -1
      call remove(buffers, index(buffers, cur))
    endif
    let buffers = [cur] + buffers
  endif

  " calculate widths for basic components of the buffer list
  let len_spc = get(g:, 'airline#extensions#tabline#spaces_around_buffer_name', 1) ? s:strchars(g:airline_symbols.space) : 0
  let len_buffers_label = s:strchars(get(g:, 'airline#extensions#tabline#buffers_label', 'buffers'))
  let len_divider = 1 " Should always be a single symbol (REVISIT: Is this really always the case?)
  let len_ellipsis = s:strchars(get(g:, 'airline#extensions#tabline#ellipsis', '...')) + len_divider

  " show_tab_type=1 adds '< buffers ' to the right of the tabline
  " Otherwise, there is 1 extra space after the last divider (always ' ' independent of spc)
  let len_extra = get(g:, 'airline#extensions#tabline#show_tab_type', 1) ? buffers_label + (2*len_spc) + len_divider : 1

  " calculate widths for the various buffer names
  let total_width = 0
  let max_width = 0
  let widths = []
  for nr in buffers
    let width = s:strchars(airline#extensions#tabline#get_buffer_name(nr)) + len_divider + (2*len_spc)
    call add(widths, width)

    let total_width += width
    let max_width = max([max_width, width])
  endfor

  " only show current and surrounding buffers if there are too many buffers
  let position  = index(buffers, cur)
  let vimwidth = &columns - len_extra
  if total_width > vimwidth
    let buf_count = len(buffers)

    " If no buffer is selected, we draw using the previous position
    if position == -1 && exists('s:previous_buffer_position')
      let position = s:previous_buffer_position
    endif

    " clamp position to 0..buf_count-1, just in case
    if position >= buf_count
      let position = buf_count-1
    elseif position < 0
      let position = 0
    endif

    " Build up buffers list
    " The current buffer always goes into the list, and there's always one space after the last divider
    let new_width = widths[position]
    let new_buffers = [buffers[position]]
    let left_pos = position-1
    let right_pos = position+1

    " Add buffers to tabline alternating right->left->right->... while buffers fit
    " Note: When no more buffers are added to the list, we add one ellipsis to each incomplete side.
    "       This effectively reduces the available width as long as either side is incomplete.
    let do_break = 0
    while !do_break
      let do_break = 1

      " Buffer after
      if right_pos < buf_count " buf_count := no more buffers to the right

        " ellipsis if this is not the last buffer + ellipsis if there are buffers remaining to the left
        let worst_case_ellipsis_width = ((right_pos < buf_count-1) + (left_pos >= 0)) * len_ellipsis

        if new_width + widths[right_pos] < vimwidth - worst_case_ellipsis_width
          let new_width += widths[right_pos]
          call add(new_buffers, buffers[right_pos])
          let right_pos += 1
          let do_break = 0
        endif

      endif

      " Buffer before
      if left_pos >= 0 " -1 := no more buffers to the left

        " ellipsis if there are buffers remaining to the right + ellipsis if this is not the first buffer
        let worst_case_ellipsis_width = ((right_pos < buf_count) + (left_pos > 0)) * len_ellipsis

        if new_width + widths[left_pos] < vimwidth - worst_case_ellipsis_width
          let new_width += widths[left_pos]
          call insert(new_buffers, buffers[left_pos], 0)
          let left_pos -= 1
          let do_break = 0
        endif

      endif
    endwhile

    " Add ellipsis
    if left_pos >= 0
      call insert(new_buffers, -1, 0)
    endif
    if right_pos < buf_count
      call add(new_buffers, -1)
    endif

    let buffers = new_buffers
  endif

  let s:previous_buffer_position = position
  let s:current_visible_buffers = buffers
  return buffers
endfunction

function! s:select_tab(buf_index)
  " no-op when called in 'keymap_ignored_filetypes'
  if count(get(g:, 'airline#extensions#tabline#keymap_ignored_filetypes', 
        \ ['vimfiler', 'nerdtree']), &ft)
    return
  endif

  let idx = a:buf_index
  if s:current_visible_buffers[0] == -1
    let idx = idx + 1
  endif

  let buf = get(s:current_visible_buffers, idx, 0)
  if buf != 0
    exec 'b!' . buf
  endif
endfunction

function! s:jump_to_tab(offset)
    let l = airline#extensions#tabline#buflist#list()
    let i = index(l, bufnr('%'))
    if i > -1
        exec 'b!' . l[(i + a:offset) % len(l)]
    endif
endfunction

function! s:map_keys()
  if get(g:, 'airline#extensions#tabline#buffer_idx_mode', 1)
    noremap <silent> <Plug>AirlineSelectTab1 :call <SID>select_tab(0)<CR>
    noremap <silent> <Plug>AirlineSelectTab2 :call <SID>select_tab(1)<CR>
    noremap <silent> <Plug>AirlineSelectTab3 :call <SID>select_tab(2)<CR>
    noremap <silent> <Plug>AirlineSelectTab4 :call <SID>select_tab(3)<CR>
    noremap <silent> <Plug>AirlineSelectTab5 :call <SID>select_tab(4)<CR>
    noremap <silent> <Plug>AirlineSelectTab6 :call <SID>select_tab(5)<CR>
    noremap <silent> <Plug>AirlineSelectTab7 :call <SID>select_tab(6)<CR>
    noremap <silent> <Plug>AirlineSelectTab8 :call <SID>select_tab(7)<CR>
    noremap <silent> <Plug>AirlineSelectTab9 :call <SID>select_tab(8)<CR>
    noremap <silent> <Plug>AirlineSelectPrevTab :<C-u>call <SID>jump_to_tab(-v:count1)<CR>
    noremap <silent> <Plug>AirlineSelectNextTab :<C-u>call <SID>jump_to_tab(v:count1)<CR>
  endif
endfunction

function! airline#extensions#tabline#buffers#clickbuf(minwid, clicks, button, modifiers) abort
    " Clickable buffers
    " works only in recent NeoVim with has('tablineat')

    " single mouse button click without modifiers pressed
    if a:clicks == 1 && a:modifiers !~# '[^ ]'
      if a:button is# 'l'
        " left button - switch to buffer
        silent execute 'buffer' a:minwid
      elseif a:button is# 'm'
        " middle button - delete buffer

        if get(g:, 'airline#extensions#tabline#middle_click_preserves_windows', 0) == 0
          " just simply delete the clicked buffer. This will cause windows
          " associated with the clicked buffer to be closed.
          silent execute 'bdelete' a:minwid
        else
          " find windows displaying the clicked buffer and open an new
          " buffer in them.
          let current_window = bufwinnr("%")
          let window_number = bufwinnr(a:minwid)
          let last_window_visited = -1

          " Set to 1 if the clicked buffer was open in any windows.
          let buffer_in_window = 0

          " Find the next window with the clicked buffer open. If bufwinnr()
          " returns the same window number, this is because we clicked a new
          " buffer, and then tried editing a new buffer. Vim won't create a
          " new empty buffer for the same window, so we get the same window
          " number from bufwinnr(). In this case we just give up and don't
          " delete the buffer.
          " This could be made cleaner if we could check if the clicked buffer
          " is a new buffer, but I don't know if there is a way to do that.
          while window_number != -1 && window_number != last_window_visited
            let buffer_in_window = 1
            silent execute window_number . 'wincmd w'
            silent execute 'enew'
            let last_window_visited = window_number
            let window_number = bufwinnr(a:minwid)
          endwhile
          silent execute current_window . 'wincmd w'
          if window_number != last_window_visited || buffer_in_window == 0
            silent execute 'bdelete' a:minwid
          endif
        endif
      endif
    endif
endfunction
