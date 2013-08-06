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

function! airline#extensions#apply_left_override(section1, section2)
  let w:airline_section_a = a:section1
  let w:airline_section_b = a:section2
  let w:airline_section_c = ''
  let w:airline_section_gutter = ' '
  let w:airline_left_only = 1
endfunction

function! airline#extensions#update_external_values()
  let g:airline_externals_tagbar = g:airline_enable_tagbar && exists(':Tagbar')
        \ ? '%(%{tagbar#currenttag("%s","")} '.g:airline_right_alt_sep.' %)' : ''
endfunction

function! airline#extensions#apply_window_overrides()
  if &buftype == 'quickfix'
    let w:airline_section_a = 'Quickfix'
    let w:airline_section_b = ''
    let w:airline_section_c = ''
    let w:airline_section_x = ''
  elseif &buftype == 'help'
    let w:airline_section_a = 'Help'
    let w:airline_section_b = '%f'
    let w:airline_section_c = ''
    let w:airline_section_gutter = ' '
    let w:airline_section_x = ''
    let w:airline_section_y = ''
  endif

  if &previewwindow
    let w:airline_section_a = 'Preview'
    let w:airline_section_b = ''
    let w:airline_section_c = bufname(winbufnr(winnr()))
  endif

  if &ft == 'netrw'
    call airline#extensions#apply_left_override('netrw', '%f')
  elseif &ft == 'unite'
    call airline#extensions#apply_left_override('Unite', '%{unite#get_status_string()}')
  elseif &ft == 'nerdtree'
    call airline#extensions#apply_left_override('NERD', '')
  elseif &ft == 'undotree'
    call airline#extensions#apply_left_override('undotree', '')
  elseif &ft == 'gundo'
    call airline#extensions#apply_left_override('Gundo', '')
  elseif &ft == 'diff'
    call airline#extensions#apply_left_override('diff', '')
  elseif &ft == 'tagbar'
    call airline#extensions#apply_left_override('Tagbar', '')
  elseif &ft == 'vimshell'
    call airline#extensions#apply_left_override('vimshell', '%{vimshell#get_status_string()}')
  elseif &ft == 'vimfiler'
    call airline#extensions#apply_left_override('vimfiler', '%{vimfiler#get_status_string()}')
  elseif &ft == 'minibufexpl'
    call airline#extensions#apply_left_override('MiniBufExplorer', '')
  elseif &ft == 'startify'
    call airline#extensions#apply_left_override('startify', '')
  endif
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

function! airline#extensions#load()
  if get(g:, 'loaded_unite', 0)
    let g:unite_force_overwrite_statusline = 0
  endif
  if get(g:, 'loaded_vimfiler', 0)
    let g:vimfiler_force_overwrite_statusline = 0
  endif

  if get(g:, 'loaded_ctrlp', 0)
    let g:ctrlp_status_func = {
          \ 'main': 'airline#extensions#ctrlp#ctrlp_airline',
          \ 'prog': 'airline#extensions#ctrlp#ctrlp_airline_status',
          \ }
  endif

  if get(g:, 'command_t_loaded', 0)
    call airline#extensions#commandt#init(s:ext)
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

  call add(g:airline_statusline_funcrefs, function('airline#extensions#update_external_values'))
  call add(g:airline_statusline_funcrefs, function('airline#extensions#apply_window_overrides'))
  call add(g:airline_exclude_funcrefs, function('airline#extensions#is_excluded_window'))

  call airline#extensions#update_external_values()
endfunction

