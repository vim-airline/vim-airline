" MIT License. Copyright (c) 2013-2021 Bailey Ling, Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

" --- Core initialization ---
if &compatible || v:version < 702 || (exists('g:loaded_airline') && g:loaded_airline)
  finish
endif
let g:loaded_airline = 1

let s:airline_initialized = 0

function! s:init()
  if s:airline_initialized
    return
  endif
  let s:airline_initialized = 1

  call airline#extensions#load()
  call airline#init#sections()

  let s:theme_in_vimrc = exists('g:airline_theme')
  if s:theme_in_vimrc
    try
      if g:airline_theme is# 'random'
        let g:airline_theme = s:random_theme()
      endif
      let l:palette = g:airline#themes#{g:airline_theme}#palette
    catch
      call airline#util#warning(printf('Could not resolve airline theme "%s".', g:airline_theme))
      let g:airline_theme = 'dark'
    endtry
    try
      silent call airline#switch_theme(g:airline_theme)
    catch
      call airline#util#warning(printf('Could not find airline theme "%s".', g:airline_theme))
      let g:airline_theme = 'dark'
      silent call airline#switch_theme(g:airline_theme)
    endtry
  else
    let g:airline_theme = 'dark'
    silent call s:on_colorscheme_changed()
  endif

  call airline#util#doautocmd('AirlineAfterInit')
endfunction

let s:active_winnr = -1

" --- Event Handlers ---

function! s:on_window_changed(event)
  if &buftype is# 'popup'
    return
  endif

  if pumvisible() && (!&previewwindow || g:airline_exclude_preview)
    return
  endif

  let s:active_winnr = winnr()
  let l:key = [bufnr('%'), s:active_winnr, winnr('$'), tabpagenr(), &filetype]

  if get(g:, 'airline_last_window_changed', []) == l:key
        \ && &statusline is# '%!airline#statusline('.s:active_winnr.')'
        \ && &filetype !~? 'gitcommit'
    if a:event ==# 'BufUnload'
      call airline#highlighter#remove_separators_for_bufnr(expand('<abuf>'))
    endif
    return
  endif

  let g:airline_last_window_changed = l:key
  call s:init()
  call airline#update_statusline()

  if a:event ==# 'BufUnload'
    call airline#highlighter#remove_separators_for_bufnr(expand('<abuf>'))
  endif
endfunction

function! s:on_focus_gained()
  if &eventignore =~? 'focusgained'
    return
  endif

  if airline#util#try_focusgained()
    unlet! w:airline_lastmode
    call s:airline_refresh(1)
  endif
endfunction

function! s:on_cursor_moved()
  if winnr() != s:active_winnr || !exists('w:airline_active')
    call s:on_window_changed('CursorMoved')
  endif
  call airline#update_tabline()
endfunction

function! s:on_colorscheme_changed()
  call s:init()
  unlet! g:airline#highlighter#normal_fg_hi
  call airline#highlighter#reset_hlcache()
  if !s:theme_in_vimrc
    call airline#switch_matching_theme()
  endif
  call airline#load_theme()
endfunction

function! airline#cmdwinenter(...)
  call airline#extensions#apply_left_override('Command Line', '')
endfunction

" --- Main Toggle Logic ---

function! s:airline_toggle()
  if exists("#airline")
    augroup airline
      autocmd!
    augroup END
    augroup! airline

    if exists("s:stl")
      let &statusline = s:stl
    endif
    if exists("s:tal")
      let [&tabline, &showtabline] = s:tal
    endif
    call airline#highlighter#reset_hlcache()
    call airline#util#doautocmd('AirlineToggledOff')
  else
    let s:stl = &statusline
    let s:tal = [&tabline, &showtabline]
    augroup airline
      autocmd!

      autocmd CmdwinEnter *
            \ call airline#add_statusline_func('airline#cmdwinenter')
            \ | call s:on_window_changed('CmdwinEnter')
      autocmd CmdwinLeave * call airline#remove_statusline_func('airline#cmdwinenter')

      autocmd ColorScheme * call s:on_colorscheme_changed()
      autocmd FocusLost * call airline#update_statusline_focuslost()
      
      autocmd SourcePre */syntax/syntax.vim
            \ call airline#extensions#tabline#buffers#invalidate()
            
      autocmd VimEnter * call s:on_window_changed('VimEnter')
      autocmd WinEnter * call s:on_window_changed('WinEnter')
      autocmd FileType * call s:on_window_changed('FileType')
      autocmd BufWinEnter * call s:on_window_changed('BufWinEnter')
      autocmd BufUnload * call s:on_window_changed('BufUnload')
      
      if exists('##CompleteDone')
        autocmd CompleteDone * call s:on_window_changed('CompleteDone')
      endif
      
      autocmd CursorMoved * call s:on_cursor_moved()
      autocmd VimResized * call s:on_focus_gained()

      if exists('*timer_start') && exists('*funcref') && &eventignore !~? 'focusgained'
        let l:Handler = funcref('s:FocusGainedHandler')
        let s:timer = timer_start(5000, l:Handler)
      else
        autocmd FocusGained * call s:on_focus_gained()
      endif

      if exists("##TerminalOpen")
        autocmd TerminalOpen * call airline#load_theme()
      endif
      
      autocmd TabEnter * unlet! w:airline_lastmode | let w:airline_active = 1
      
      autocmd BufWritePost */autoload/airline/themes/*.vim
            \ execute 'source '.split(globpath(&rtp, 'autoload/airline/themes/'.g:airline_theme.'.vim', 1), "\n")[0]
            \ | call airline#load_theme()
            
      autocmd User AirlineModeChanged nested call airline#mode_changed()

      if get(g:, 'airline_statusline_ontop', 0)
        autocmd InsertEnter,InsertLeave,CursorMovedI * call airline#update_tabline()
      endif

      if exists("##ModeChanged")
        autocmd ModeChanged * call airline#update_tabline()
      endif
    augroup END

    if !airline#util#stl_disabled(winnr())
      if &laststatus < 2
        let l:scroll_bak = &scroll
        if !get(g:, 'airline_statusline_ontop', 0)
          set laststatus=2
        endif
        let &scroll = l:scroll_bak
      endif
    endif

    if airline#util#has_multiline() && &statuslineopt !~# 'maxheight:'
      set statuslineopt+=maxheight:2
    endif

    if s:airline_initialized
      call s:on_window_changed('Init')
    endif

    call airline#util#doautocmd('AirlineToggledOn')
  endif
endfunction

" --- Helper Functions ---

function! s:get_airline_themes(a, l, p)
  return airline#util#themes(a:a)
endfunction

function! s:airline_theme(...)
  if a:0
    try
      let l:theme = a:1
      if l:theme is# 'random'
        let l:theme = s:random_theme()
      endif
      call airline#switch_theme(l:theme)
    catch
    endtry
    if a:1 is# 'random'
      echo g:airline_theme
    endif
  else
    echo g:airline_theme
  endif
endfunction

function! s:airline_refresh(...)
  let l:fast = !empty(get(a:000, 0, 0))
  if !exists("#airline")
    return
  endif
  call airline#util#doautocmd('AirlineBeforeRefresh')
  call airline#highlighter#reset_hlcache()
  if !l:fast
    call airline#load_theme()
  endif
  call airline#update_statusline()
  call airline#update_tabline()
endfunction

function! s:FocusGainedHandler(timer)
  if exists("s:timer") && a:timer == s:timer && exists('#airline') && &eventignore !~? 'focusgained'
    augroup airline
      autocmd FocusGained * call s:on_focus_gained()
    augroup END
  endif
endfunction

function! s:airline_extensions()
  let l:loaded = airline#extensions#get_loaded_extensions()
  let l:files = split(globpath(&rtp, 'autoload/airline/extensions/*.vim', 1), "\n")
  call map(l:files, 'fnamemodify(v:val, ":t:r")')
  if empty(l:files)
    echo "No extensions loaded"
    return
  endif
  echohl Title
  echo printf("%-15s\t%s\t%s", "Extension", "Extern", "Status")
  echohl Normal
  let l:set = []
  let l:not_loaded = []
  for l:ext in sort(l:files)
    if index(l:set + l:not_loaded, l:ext) > -1
      continue
    endif
    let l:indx = match(l:loaded, '^'.l:ext.'\*\?$')
    if l:indx == -1
      call add(l:not_loaded, l:ext)
      continue
    endif
    call add(l:set, l:ext)
    let l:external = (l:loaded[l:indx] =~ '\*$')
    echo printf("%-15s\t%s\tloaded", l:ext, l:external)
  endfor
  for l:ext in l:not_loaded
    echo printf("%-15s\t%s\tnot loaded", l:ext, 0)
  endfor
endfunction

function! s:rand(max) abort
  if exists("*rand")
    let l:number = rand()
  elseif has("reltime")
    let l:timerstr = reltimestr(reltime())
    let l:number = split(l:timerstr, '\.')[1] + 0
  elseif has("win32") && &shell =~? 'cmd'
    let l:number = system("echo %random%") + 0
  else
    let l:number = expand("$RANDOM") + 0
  endif
  return l:number % a:max
endfunction

function! s:random_theme() abort
  let l:themes = airline#util#themes('')
  return l:themes[s:rand(len(l:themes))]
endfunction

" --- Commands & Bootstrap ---

command! -bar -nargs=? -complete=customlist,s:get_airline_themes AirlineTheme call s:airline_theme(<f-args>)
command! -bar AirlineToggleWhitespace call airline#extensions#whitespace#toggle()
command! -bar AirlineToggle  call s:airline_toggle()
command! -bar -bang AirlineRefresh call s:airline_refresh(<q-bang>)
command! AirlineExtensions   call s:airline_extensions()

call airline#init#bootstrap()
call s:airline_toggle()

if exists("v:vim_did_enter") && v:vim_did_enter
  call s:on_window_changed('VimEnter')
endif

let &cpo = s:save_cpo
unlet s:save_cpo
