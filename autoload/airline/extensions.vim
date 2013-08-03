" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#extensions#apply_left_override(section1, section2)
  let w:airline_section_a = a:section1
  let w:airline_section_b = a:section2
  let w:airline_section_c = ''
  let w:airline_section_gutter = ' '
  let w:airline_left_only = 1
endfunction

function! airline#extensions#update_external_values()
  let g:airline_externals_bufferline = g:airline_enable_bufferline && exists('*bufferline#get_status_string')
        \ ? '%{bufferline#refresh_status()}'.bufferline#get_status_string() : "%f%m"
  let g:airline_externals_syntastic = g:airline_enable_syntastic && exists('*SyntasticStatuslineFlag')
        \ ? '%#warningmsg#%{SyntasticStatuslineFlag()}' : ''
  let g:airline_externals_branch = g:airline_enable_branch
        \ ? (exists('*fugitive#head') && strlen(fugitive#head()) > 0
          \ ? g:airline_branch_prefix.fugitive#head()
          \ : exists('*lawrencium#statusline') && strlen(lawrencium#statusline()) > 0
            \ ? g:airline_branch_prefix.lawrencium#statusline()
            \ : '')
        \ : ''
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
    call add(g:airline_statusline_funcrefs, function('airline#extensions#commandt#apply_window_override'))
  endif

  if g:airline_enable_bufferline && get(g:, 'loaded_bufferline', 0)
    highlight AlBl_active gui=bold cterm=bold term=bold
    highlight link AlBl_inactive Al6
    let g:bufferline_inactive_highlight = 'AlBl_inactive'
    let g:bufferline_active_highlight = 'AlBl_active'
    let g:bufferline_active_buffer_left = ''
    let g:bufferline_active_buffer_right = ''
    let g:bufferline_separator = ' '
  endif

  call add(g:airline_statusline_funcrefs, function('airline#extensions#update_external_values'))
  call add(g:airline_statusline_funcrefs, function('airline#extensions#apply_window_overrides'))
  call add(g:airline_exclude_funcrefs, function('airline#extensions#is_excluded_window'))

  call airline#extensions#update_external_values()
endfunction

