" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

let s:ext = {}
let s:ext._cursormove_funcrefs = []
function! s:ext.add_statusline_funcref(funcref) dict
  call add(g:airline_statusline_funcrefs, a:funcref)
endfunction
function! s:ext.add_cursormove_funcref(funcref) dict
  call add(self._cursormove_funcrefs, a:funcref)
endfunction

let s:filetype_overrides = {
      \ 'netrw': [ 'netrw', '%f' ],
      \ 'unite': [ 'Unite', '%{unite#get_status_string()}' ],
      \ 'nerdtree': [ 'NERD', '' ],
      \ 'undotree': [ 'undotree', '' ],
      \ 'gundo': [ 'Gundo', '' ],
      \ 'diff': [ 'diff', '' ],
      \ 'vimfiler': [ 'vimfiler', '%{vimfiler#get_status_string()}' ],
      \ 'minibufexpl': [ 'MiniBufExplorer', '' ],
      \ 'startify': [ 'startify', '' ],
      \ }

let s:filetype_regex_overrides = {}

function! airline#extensions#apply_left_override(section1, section2)
  let w:airline_section_a = a:section1
  let w:airline_section_b = a:section2
  let w:airline_section_c = ''
  let w:airline_render_left = 1
  let w:airline_render_right = 0
endfunction

let s:active_winnr = -1
function! airline#extensions#update_statusline()
  let s:active_winnr = winnr()

  if &buftype == 'quickfix'
    let w:airline_section_a = 'Quickfix'
    let w:airline_section_b = ''
    let w:airline_section_c = ''
    let w:airline_section_x = ''
  elseif &buftype == 'help'
    call airline#extensions#apply_left_override('Help', '%f')
    let w:airline_section_x = ''
    let w:airline_section_y = ''
    let w:airline_render_right = 1
  endif

  if &previewwindow
    let w:airline_section_a = 'Preview'
    let w:airline_section_b = ''
    let w:airline_section_c = bufname(winbufnr(winnr()))
  endif

  if has_key(s:filetype_overrides, &ft)
    let args = s:filetype_overrides[&ft]
    call airline#extensions#apply_left_override(args[0], args[1])
  endif

  for item in items(s:filetype_regex_overrides)
    if match(&ft, item[0]) >= 0
      call airline#extensions#apply_left_override(item[1][0], item[1][1])
    endif
  endfor
endfunction

function! airline#extensions#is_excluded_window()
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

  if g:airline_exclude_preview && &previewwindow
    return 1
  endif

  return 0
endfunction

function! airline#extensions#load_theme()
  if get(g:, 'loaded_ctrlp', 0)
    call airline#extensions#ctrlp#load_theme()
  endif
endfunction

function! s:sync_active_winnr()
  if winnr() != s:active_winnr
    if airline#exec_funcrefs(s:ext._cursormove_funcrefs, 1)
      return
    endif
    call airline#update_statusline()
  endif
endfunction

function! airline#extensions#load()
  " non-trivial number of external plugins use eventignore=all, so we need to account for that
  autocmd CursorMoved * call <sid>sync_active_winnr()

  " load core funcrefs
  call add(g:airline_exclude_funcrefs, function('airline#extensions#is_excluded_window'))
  call add(g:airline_statusline_funcrefs, function('airline#extensions#update_statusline'))

  if get(g:, 'loaded_unite', 0)
    let g:unite_force_overwrite_statusline = 0
  endif

  if get(g:, 'loaded_vimfiler', 0)
    let g:vimfiler_force_overwrite_statusline = 0
  endif

  if get(g:, 'loaded_ctrlp', 0)
    call airline#extensions#ctrlp#init(s:ext)
  endif

  if get(g:, 'command_t_loaded', 0)
    call airline#extensions#commandt#init(s:ext)
  endif

  if g:airline_enable_tagbar && exists(':TagbarToggle')
    call airline#extensions#tagbar#init(s:ext)
  endif

  if g:airline_enable_csv && exists(':Table')
    call airline#extensions#csv#init(s:ext)
  endif

  if exists(':VimShell')
    let s:filetype_overrides['vimshell'] = ['vimshell','%{vimshell#get_status_string()}']
    let s:filetype_regex_overrides['^int-'] = ['vimshell','%{substitute(&ft, "int-", "", "")}']
  endif

  if g:airline_enable_branch && (get(g:, 'loaded_fugitive', 0) || get(g:, 'loaded_lawrencium', 0))
    call airline#extensions#branch#init(s:ext)
  endif

  if g:airline_enable_syntastic && get(g:, 'loaded_syntastic_plugin')
    call airline#extensions#syntastic#init(s:ext)
  endif

  if g:airline_enable_bufferline && exists('*bufferline#get_status_string')
    call airline#extensions#bufferline#init(s:ext)
  endif

  if g:airline_detect_whitespace
    call airline#extensions#whitespace#init()
  endif

  if g:airline_detect_iminsert
    call airline#extensions#iminsert#init()
  endif

  call airline#exec_funcrefs(g:airline_statusline_funcrefs, 0)
endfunction

