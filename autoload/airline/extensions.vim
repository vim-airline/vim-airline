" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:ext = {}
function! s:ext.add_statusline_func(name) dict
  call airline#add_statusline_func(a:name)
endfunction
function! s:ext.add_statusline_funcref(function) dict
  call airline#add_statusline_funcref(a:function)
endfunction

let s:script_path = expand('<sfile>:p:h')

let s:filetype_overrides = {
      \ 'netrw': [ 'netrw', '%f' ],
      \ 'nerdtree': [ 'NERD', '' ],
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
function! airline#extensions#update_statusline(...)
  if s:is_excluded_window(a:000)
    return -1
  endif

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

function! s:is_excluded_window(...)
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
  if exists('#airline') && winnr() != s:active_winnr
    call airline#update_statusline()
  endif
endfunction

function! airline#extensions#load()
  " non-trivial number of external plugins use eventignore=all, so we need to account for that
  autocmd CursorMoved * call <sid>sync_active_winnr()

  " load core funcrefs
  call airline#add_statusline_func('airline#extensions#update_statusline')

  if get(g:, 'loaded_unite', 0)
    call airline#extensions#unite#init(s:ext)
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

  if exists(':UndotreeToggle')
    call airline#extensions#undotree#init(s:ext)
  endif

  if (get(g:, 'airline#extensions#hunks#enabled', 1) && get(g:, 'airline_enable_hunks', 1))
        \ && (exists('g:loaded_signify') || exists('g:loaded_gitgutter'))
    call airline#extensions#hunks#init(s:ext)
  endif

  if (get(g:, 'airline#extensions#tagbar#enabled', 1) && get(g:, 'airline_enable_tagbar', 1))
        \ && exists(':TagbarToggle')
    call airline#extensions#tagbar#init(s:ext)
  endif

  if (get(g:, 'airline#extensions#csv#enabled', 1) && get(g:, 'airline_enable_csv', 1))
        \ && (get(g:, 'loaded_csv', 0) || exists(':Table'))
    call airline#extensions#csv#init(s:ext)
  endif

  if exists(':VimShell')
    let s:filetype_overrides['vimshell'] = ['vimshell','%{vimshell#get_status_string()}']
    let s:filetype_regex_overrides['^int-'] = ['vimshell','%{substitute(&ft, "int-", "", "")}']
  endif

  if (get(g:, 'airline#extensions#branch#enabled', 1) && get(g:, 'airline_enable_branch', 1))
        \ && (get(g:, 'loaded_fugitive', 0) || get(g:, 'loaded_lawrencium', 0))
    call airline#extensions#branch#init(s:ext)
  endif

  if (get(g:, 'airline#extensions#bufferline#enabled', 1) && get(g:, 'airline_enable_bufferline', 1))
        \ && exists('*bufferline#get_status_string')
    call airline#extensions#bufferline#init(s:ext)
  endif

  if g:airline_section_warning == '__'
    if (get(g:, 'airline#extensions#syntastic#enabled', 1) && get(g:, 'airline_enable_syntastic', 1))
          \ && exists(':SyntasticCheck')
      call airline#extensions#syntastic#init(s:ext)
    endif

    if (get(g:, 'airline#extensions#whitespace#enabled', 1) && get(g:, 'airline_detect_whitespace', 1))
      call airline#extensions#whitespace#init(s:ext)
    endif
  endif

  if get(g:, 'airline#extensions#readonly#enabled', 1)
    call airline#extensions#readonly#init()
  endif

  if (get(g:, 'airline#extensions#paste#enabled', 1) && get(g:, 'airline_detect_paste', 1))
    call airline#extensions#paste#init()
  endif

  if g:airline_detect_iminsert
    call airline#extensions#iminsert#init()
  endif

  " load all other extensions not part of the default distribution
  for file in split(globpath(&rtp, "autoload/airline/extensions/*.vim"), '\n')
    if stridx(resolve(fnamemodify(file, ':p')), s:script_path) < 0
      let name = fnamemodify(file, ':t:r')
      if !get(g:, 'airline#extensions#'.name.'#enabled', 1)
        continue
      endif
      call airline#extensions#{name}#init(s:ext)
    endif
  endfor
endfunction

