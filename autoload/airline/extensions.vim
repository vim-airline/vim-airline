" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:ext = {}
let s:ext._theme_funcrefs = []

function! s:ext.add_statusline_func(name) dict
  call airline#add_statusline_func(a:name)
endfunction
function! s:ext.add_statusline_funcref(function) dict
  call airline#add_statusline_funcref(a:function)
endfunction
function! s:ext.add_inactive_statusline_func(name) dict
  call airline#add_inactive_statusline_func(a:name)
endfunction
function! s:ext.add_theme_func(name) dict
  call add(self._theme_funcrefs, function(a:name))
endfunction

let s:script_path = tolower(resolve(expand('<sfile>:p:h')))

let s:filetype_overrides = {
      \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', 'NERD'), '' ],
      \ 'gundo': [ 'Gundo', '' ],
      \ 'vimfiler': [ 'vimfiler', '%{vimfiler#get_status_string()}' ],
      \ 'minibufexpl': [ 'MiniBufExplorer', '' ],
      \ 'startify': [ 'startify', '' ],
      \ 'vim-plug': [ 'Plugins', '' ],
      \ }

let s:filetype_regex_overrides = {}

function! s:check_defined_section(name)
  if !exists('w:airline_section_{a:name}')
    let w:airline_section_{a:name} = g:airline_section_{a:name}
  endif
endfunction

function! airline#extensions#append_to_section(name, value)
  call <sid>check_defined_section(a:name)
  let w:airline_section_{a:name} .= a:value
endfunction

function! airline#extensions#prepend_to_section(name, value)
  call <sid>check_defined_section(a:name)
  let w:airline_section_{a:name} = a:value . w:airline_section_{a:name}
endfunction

function! airline#extensions#apply_left_override(section1, section2)
  let w:airline_section_a = a:section1
  let w:airline_section_b = a:section2
  let w:airline_section_c = airline#section#create(['readonly'])
  let w:airline_render_left = 1
  let w:airline_render_right = 0
endfunction

let s:active_winnr = -1
function! airline#extensions#apply(...)
  let s:active_winnr = winnr()

  if s:is_excluded_window()
    return -1
  endif

  if &buftype == 'help'
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

  if g:airline_exclude_preview && &previewwindow
    return 1
  endif

  return 0
endfunction

function! airline#extensions#load_theme()
  call airline#util#exec_funcrefs(s:ext._theme_funcrefs, g:airline#themes#{g:airline_theme}#palette)
endfunction

function! s:sync_active_winnr()
  if exists('#airline') && winnr() != s:active_winnr
    call airline#update_statusline()
  endif
endfunction

function! airline#extensions#load()
  let loaded_ext = []
  " non-trivial number of external plugins use eventignore=all, so we need to account for that
  autocmd CursorMoved * call <sid>sync_active_winnr()

  if exists('g:airline_extensions')
    for ext in g:airline_extensions
      try
        call airline#extensions#{ext}#init(s:ext)
      catch /^Vim\%((\a\+)\)\=:E117/	" E117, function does not exist
        call airline#util#warning("Extension '".ext."' not installed, ignoring!")
      endtry
    endfor
    return
  endif

  call airline#extensions#quickfix#init(s:ext)
  call add(loaded_ext, 'quickfix')

  if get(g:, 'loaded_unite', 0)
    call airline#extensions#unite#init(s:ext)
    call add(loaded_ext, 'unite')
  endif

  if get(g:, 'loaded_denite', 0)
    call airline#extensions#denite#init(s:ext)
    call add(loaded_ext, 'denite')
  endif

  if exists(':NetrwSettings')
    call airline#extensions#netrw#init(s:ext)
    call add(loaded_ext, 'netrw')
  endif

  if has("terminal")
    call airline#extensions#term#init(s:ext)
    call add(loaded_ext, 'term')
  endif

  if get(g:, 'airline#extensions#ycm#enabled', 0)
    call airline#extensions#ycm#init(s:ext)
    call add(loaded_ext, 'ycm')
  endif

  if get(g:, 'loaded_vimfiler', 0)
    let g:vimfiler_force_overwrite_statusline = 0
  endif

  if get(g:, 'loaded_ctrlp', 0)
    call airline#extensions#ctrlp#init(s:ext)
    call add(loaded_ext, 'ctrlp')
  endif

  if get(g:, 'loaded_localsearch', 0)
    call airline#extensions#localsearch#init(s:ext)
    call add(loaded_ext, 'localsearch')
  endif

  if get(g:, 'CtrlSpaceLoaded', 0)
    call airline#extensions#ctrlspace#init(s:ext)
    call add(loaded_ext, 'ctrlspace')
  endif

  if get(g:, 'command_t_loaded', 0)
    call airline#extensions#commandt#init(s:ext)
    call add(loaded_ext, 'commandt')
  endif

  if exists(':UndotreeToggle')
    call airline#extensions#undotree#init(s:ext)
    call add(loaded_ext, 'undotree')
  endif

  if get(g:, 'airline#extensions#hunks#enabled', 1)
        \ && (exists('g:loaded_signify') || exists('g:loaded_gitgutter') || exists('g:loaded_changes') || exists('g:loaded_quickfixsigns'))
    call airline#extensions#hunks#init(s:ext)
    call add(loaded_ext, 'hunks')
  endif

  if get(g:, 'airline#extensions#vimagit#enabled', 1)
        \ && (exists('g:loaded_magit'))
    call airline#extensions#vimagit#init(s:ext)
    call add(loaded_ext, 'vimagit')
  endif

  if get(g:, 'airline#extensions#tagbar#enabled', 1)
        \ && exists(':TagbarToggle')
    call airline#extensions#tagbar#init(s:ext)
    call add(loaded_ext, 'tagbar')
  endif

  if get(g:, 'airline#extensions#csv#enabled', 1)
        \ && (get(g:, 'loaded_csv', 0) || exists(':Table'))
    call airline#extensions#csv#init(s:ext)
    call add(loaded_ext, 'csv')
  endif

  if exists(':VimShell')
    let s:filetype_overrides['vimshell'] = ['vimshell','%{vimshell#get_status_string()}']
    let s:filetype_regex_overrides['^int-'] = ['vimshell','%{substitute(&ft, "int-", "", "")}']
  endif

  if get(g:, 'airline#extensions#branch#enabled', 1)
        \ && (exists('*fugitive#head') || exists('*lawrencium#statusline') ||
        \     (get(g:, 'airline#extensions#branch#use_vcscommand', 0) && exists('*VCSCommandGetStatusLine')))
    call airline#extensions#branch#init(s:ext)
    call add(loaded_ext, 'branch')
  endif

  if get(g:, 'airline#extensions#bufferline#enabled', 1)
        \ && exists('*bufferline#get_status_string')
    call airline#extensions#bufferline#init(s:ext)
    call add(loaded_ext, 'bufferline')
  endif

  if get(g:, 'airline#extensions#fugitiveline#enabled', 1)
        \ && exists('*fugitive#head')
        \ && index(loaded_ext, 'bufferline') == -1
    call airline#extensions#fugitiveline#init(s:ext)
    call add(loaded_ext, 'fugitiveline')
  endif

  if (get(g:, 'airline#extensions#virtualenv#enabled', 1) && (exists(':VirtualEnvList') || isdirectory($VIRTUAL_ENV)))
    call airline#extensions#virtualenv#init(s:ext)
    call add(loaded_ext, 'virtualenv')
  endif

  if (get(g:, 'airline#extensions#eclim#enabled', 1) && exists(':ProjectCreate'))
    call airline#extensions#eclim#init(s:ext)
    call add(loaded_ext, 'eclim')
  endif

  if get(g:, 'airline#extensions#syntastic#enabled', 1)
        \ && exists(':SyntasticCheck')
    call airline#extensions#syntastic#init(s:ext)
    call add(loaded_ext, 'syntastic')
  endif

  if (get(g:, 'airline#extensions#ale#enabled', 1) && exists(':ALELint'))
    call airline#extensions#ale#init(s:ext)
    call add(loaded_ext, 'ale')
  endif

  if get(g:, 'airline#extensions#whitespace#enabled', 1)
    call airline#extensions#whitespace#init(s:ext)
    call add(loaded_ext, 'whitespace')
  endif

  if (get(g:, 'airline#extensions#neomake#enabled', 1) && exists(':Neomake'))
    call airline#extensions#neomake#init(s:ext)
    call add(loaded_ext, 'neomake')
  endif

  if get(g:, 'airline#extensions#po#enabled', 1) && executable('msgfmt')
    call airline#extensions#po#init(s:ext)
    call add(loaded_ext, 'po')
  endif

  if get(g:, 'airline#extensions#wordcount#enabled', 1)
    call airline#extensions#wordcount#init(s:ext)
    call add(loaded_ext, 'wordcount')
  endif

  if get(g:, 'airline#extensions#tabline#enabled', 0)
    call airline#extensions#tabline#init(s:ext)
    call add(loaded_ext, 'tabline')
  endif

  if get(g:, 'airline#extensions#tmuxline#enabled', 1) && exists(':Tmuxline')
    call airline#extensions#tmuxline#init(s:ext)
    call add(loaded_ext, 'tmuxline')
  endif

  if get(g:, 'airline#extensions#promptline#enabled', 1) && exists(':PromptlineSnapshot') && len(get(g:, 'airline#extensions#promptline#snapshot_file', ''))
    call airline#extensions#promptline#init(s:ext)
    call add(loaded_ext, 'promptline')
  endif

  if get(g:, 'airline#extensions#nrrwrgn#enabled', 1) && exists(':NR') == 2
      call airline#extensions#nrrwrgn#init(s:ext)
    call add(loaded_ext, 'nrrwrgn')
  endif

  if get(g:, 'airline#extensions#unicode#enabled', 1) && exists(':UnicodeTable') == 2
      call airline#extensions#unicode#init(s:ext)
    call add(loaded_ext, 'nrrwrgn')
  endif

  if (get(g:, 'airline#extensions#capslock#enabled', 1) && exists('*CapsLockStatusline'))
    call airline#extensions#capslock#init(s:ext)
    call add(loaded_ext, 'capslock')
  endif

  if (get(g:, 'airline#extensions#gutentags#enabled', 1) && get(g:, 'loaded_gutentags', 0))
    call airline#extensions#gutentags#init(s:ext)
    call add(loaded_ext, 'gutentags')
  endif

  if (get(g:, 'airline#extensions#xkblayout#enabled', 1) && exists('g:XkbSwitchLib'))
    call airline#extensions#xkblayout#init(s:ext)
    call add(loaded_ext, 'xkblayout')
  endif

  if (get(g:, 'airline#extensions#keymap#enabled', 1) && has('keymap'))
    call airline#extensions#keymap#init(s:ext)
    call add(loaded_ext, 'keymap')
  endif

  if (get(g:, 'airline#extensions#windowswap#enabled', 1) && get(g:, 'loaded_windowswap', 0))
    call airline#extensions#windowswap#init(s:ext)
    call add(loaded_ext, 'windowswap')
  endif

  if (get(g:, 'airline#extensions#obsession#enabled', 1) && exists('*ObsessionStatus'))
    call airline#extensions#obsession#init(s:ext)
    call add(loaded_ext, 'obsession')
  endif

  runtime autoload/vimtex.vim
  if (get(g:, 'airline#extensions#vimtex#enabled', 1)) && exists('*vimtex#init')
   call airline#extensions#vimtex#init(s:ext)
   call add(loaded_ext, 'vimtex')
  endif

  if (get(g:, 'airline#extensions#cursormode#enabled', 0))
    call airline#extensions#cursormode#init(s:ext)
    call add(loaded_ext, 'cursormode')
  endif

  if !get(g:, 'airline#extensions#disable_rtp_load', 0)
    " load all other extensions, which are not part of the default distribution.
    " (autoload/airline/extensions/*.vim outside of our s:script_path).
    for file in split(globpath(&rtp, "autoload/airline/extensions/*.vim"), "\n")
      " we have to check both resolved and unresolved paths, since it's possible
      " that they might not get resolved properly (see #187)
      if stridx(tolower(resolve(fnamemodify(file, ':p'))), s:script_path) < 0
            \ && stridx(tolower(fnamemodify(file, ':p')), s:script_path) < 0
        let name = fnamemodify(file, ':t:r')
        if !get(g:, 'airline#extensions#'.name.'#enabled', 1) ||
            \ index(loaded_ext, name) > -1
          continue
        endif
        try
          call airline#extensions#{name}#init(s:ext)
        catch
        endtry
      endif
    endfor
  endif
endfunction
