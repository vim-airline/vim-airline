" vim: ts=2 sts=2 sw=2 fdm=indent
let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running')
let s:load_the_theme = g:airline#themes#{g:airline_theme}#normal

let s:airline_highlight_map = {
      \ 'mode'           : 'Al2',
      \ 'mode_separator' : 'Al3',
      \ 'info'           : 'Al4',
      \ 'info_separator' : 'Al5',
      \ 'statusline'     : 'Al6',
      \ 'file'           : 'Al7',
      \ 'inactive'       : 'Al9',
      \ }
let s:airline_highlight_groups = keys(s:airline_highlight_map)

function! airline#highlight(modes)
  " always draw the base mode, and then override any/all of the colors with _override
  let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
  for mode in mapped
    for key in s:airline_highlight_groups
      if exists('g:airline#themes#{g:airline_theme}#{mode}[key]')
        let colors = g:airline#themes#{g:airline_theme}#{mode}[key]
        if s:is_win32term
          let colors = map(colors, 'v:val != "" && v:val > 128 ? v:val - 128 : v:val')
        endif
        exec printf('hi %s %s %s %s %s %s %s',
              \ s:airline_highlight_map[key],
              \ colors[0] != '' ? 'guifg='.colors[0] : '',
              \ colors[1] != '' ? 'guibg='.colors[1] : '',
              \ colors[2] != '' ? 'ctermfg='.colors[2] : '',
              \ colors[3] != '' ? 'ctermbg='.colors[3] : '',
              \ colors[4] != '' ? 'gui='.colors[4] : '',
              \ colors[4] != '' ? 'term='.colors[4] : '')
      endif
    endfor
  endfor
endfunction

function! s:is_excluded_window()
  for matchft in g:airline_exclude_filetypes
    if matchft ==# &ft
      return 1
    endif
  endfor
  for matchw in g:airline_exclude_filenames
    if matchstr(expand('%'), matchw) ==# matchw
      return 1
    endif
  endfor
  return 0
endfunction

function! s:apply_window_overrides()
  if &buftype == 'quickfix'
    let w:airline_section_a = 'Quickfix'
    let w:airline_section_b = ''
    let w:airline_section_c = ''
    let w:airline_section_x = ''
  endif

  if &previewwindow
    let w:airline_section_a = 'Preview'
    let w:airline_section_b = ''
    let w:airline_section_c = bufname(winbufnr(winnr()))
  endif
endfunction

function! airline#update_externals()
  let g:airline_externals_bufferline = g:airline_enable_bufferline && exists('g:bufferline_loaded') ? '%{bufferline#generate_string()}' : "%f%m"
  let g:airline_externals_syntastic = g:airline_enable_syntastic && exists('g:loaded_syntastic_plugin') ? '%{SyntasticStatuslineFlag()}' : ''
  let g:airline_externals_fugitive = g:airline_enable_fugitive && exists('g:loaded_fugitive') && strlen(fugitive#head()) > 0
        \ ? g:airline_fugitive_prefix.fugitive#head() : ''
endfunction

function! s:get_section(key)
  return exists('w:airline_section_{a:key}') ? w:airline_section_{a:key} : g:airline_section_{a:key}
endfunction

function! airline#update_statusline(active)
  if s:is_excluded_window()
    call setwinvar(winnr(), '&statusline', '')
    return
  endif

  call airline#update_externals()
  call s:apply_window_overrides()

  let l:mode_color      = a:active ? "%#Al2#" : "%#Al9#"
  let l:mode_sep_color  = a:active ? "%#Al3#" : "%#Al9#"
  let l:info_color      = a:active ? "%#Al4#" : "%#Al9#"
  let l:info_sep_color  = a:active ? "%#Al5#" : "%#Al9#"
  let l:status_color    = a:active ? "%#Al6#" : "%#Al9#"
  let l:file_flag_color = a:active ? "%#Al7#" : "%#Al9#"

  let sl = l:mode_color
  let sl.= a:active
        \ ? '%{airline#update_highlight()} '.s:get_section('a').' %{&paste ? g:airline_paste_symbol." " : ""}'
        \ : ' '.s:get_section('a').' %#Al9#'
  let sl.=l:mode_sep_color.g:airline_left_sep.l:info_color
  let sl.=' '.s:get_section('b').' '
  let sl.=l:info_sep_color.g:airline_left_sep
  let sl.=a:active ? l:status_color.' '.s:get_section('c').' ' : ' '.bufname(winbufnr(winnr()))
  let sl.='%#warningmsg#'.g:airline_externals_syntastic
  let sl.=l:status_color."%<%=".l:file_flag_color."%{&ro ? g:airline_readonly_symbol : ''}".l:status_color
  let sl.=' '.s:get_section('x').' '
  let sl.=l:info_sep_color.g:airline_right_sep.l:info_color
  let sl.=' '.s:get_section('y').' '
  let sl.=l:mode_sep_color.g:airline_right_sep.l:mode_color
  let sl.=' '.s:get_section('z').' '
  call setwinvar(winnr(), '&statusline', sl)
endfunction

let s:lastmode = ''
let g:airline_current_mode_text = ''
function! airline#update_highlight()
  let l:m = mode()
  if l:m ==# "i" || l:m ==# "R"
    let l:mode = ['insert']
  elseif l:m ==? "v" || l:m ==# ""
    let l:mode = ['visual']
  else
    let l:mode = ['normal']
  endif

  if &modified
    call add(l:mode, 'modified')
  endif
  if &paste
    call add(l:mode, 'paste')
  endif
  if &previewwindow
    call add(l:mode, 'preview')
  endif

  let mode_string = join(l:mode)
  if s:lastmode != mode_string
    call airline#highlight(l:mode)
    let s:lastmode = mode_string
  endif

  let g:airline_current_mode_text = get(g:airline_mode_map, l:m, l:m)
  return ''
endfunction
