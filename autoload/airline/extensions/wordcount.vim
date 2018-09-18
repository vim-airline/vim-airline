" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2 fdm=marker

scriptencoding utf-8

" get wordcount {{{1
if exists('*wordcount')
  function! s:get_wordcount(type)
    return string(wordcount()[a:type])
  endfunction
else
  function! s:get_wordcount(type)
    " index to retrieve from whitespace-separated output of g_CTRL-G
    " 11 : words, 5 : visual words (in visual mode)
    let idx = (a:type == 'words') ? 11 : 5

    let save_status = v:statusmsg
    execute "silent normal! g\<cn-g>"
    let stat = v:statusmsg
    let v:statusmsg = save_status

    let parts = split(stat)
    if len(parts) > idx
      return parts[idx]
    endif
  endfunction
endif

" format {{{1
let s:formatter = get(g:, 'airline#extensions#wordcount#formatter', 'default')

" wrapper function for compatibility; redefined below for old-style formatters
function! s:format_wordcount(type)
  return airline#extensions#wordcount#formatters#{s:formatter}#to_string(
        \ s:get_wordcount(a:type))
endfunction

" check user-defined formatter exists and has appropriate functions, otherwise
" fall back to default
if s:formatter !=# 'default'
  execute 'runtime! autoload/airline/extensions/wordcount/formatters/'.s:formatter
  if !exists('*airline#extensions#wordcount#formatters#{s:formatter}#to_string')
    if !exists('*airline#extensions#wordcount#formatters#{s:formatter}#format')
      let s:formatter = 'default'
    else
      " redefine for backwords compatibility
      function! s:format_wordcount(type)
        if a:type !=# 'visual_words'
          return airline#extensions#wordcount#formatters#{s:formatter}#format()
        endif
      endfunction
    endif
  endif
endif

" update {{{1
if exists('##TextChanged')
  let s:supported_autocmds = 'TextChanged,TextChangedI'

  function! s:update_wordcount()
    let b:airline_wordcount = s:format_wordcount('words')
  endfunction
else
  let s:supported_autocmds = 'CursorMoved,CursorMovedI'

  " without TextChanged a check is performed on every cursor movement, so
  " cache for performance
  function! s:update_wordcount()
    if get(b:, 'airline_wordcount_cache', '') is# '' ||
          \ get(b:, 'airline_change_tick', 0) != b:changedtick ||
          \ get(b:, 'airline_winwidth', 0) != winwidth(0)
      let b:airline_wordcount = s:format_wordcount('words')
      let b:airline_wordcount_cache = b:airline_wordcount
      let b:airline_change_tick = b:changedtick
      let b:airline_winwidth = winwidth(0)
    endif
  endfunction
endif

" public {{{1
" s:visual tracks visual mode
function airline#extensions#wordcount#get()
  return s:visual
        \ ? s:format_wordcount('visual_words')
        \ : get(b:, 'airline_wordcount', '')
endfunction

" autocmds & airline functions {{{1
function s:modify_autocmds()
    if !exists('#airline_wordcount#BufEnter#')
      execute 'autocmd! airline_wordcount BufEnter,'.s:supported_autocmds
            \  .' <buffer> nested call s:update_wordcount()'
      " ensure we have a starting wordcount
      call s:update_wordcount()
    else
     execute 'autocmd! airline_wordcount BufEnter,'.'s:supported_autocmds'
    endif
endfunction

" default filetypes
let s:filetypes = ['help', 'markdown', 'rst', 'org', 'text', 'asciidoc', 'tex', 'mail']

function! airline#extensions#wordcount#apply(...)
  let filetypes = get(g:, 'airline#extensions#wordcount#filetypes', s:filetypes)

  " filetypes used to be a regex-matching string, so check both
  if type(filetypes) == v:t_list
        \    && (index(filetypes, &filetype) > -1 || empty(filetypes))
        \ || type(filetypes) == v:t_string && match(&ft, filetypes) > -1
    " redo autocommands if filetype has changed
    if filetypes isnot s:filetypes || did_filetype()
      call s:modify_autocmds()
      let s:filetypes = filetypes
    endif

    call airline#extensions#prepend_to_section(
          \ 'z', '%{airline#extensions#wordcount#get()}')
  endif
endfunction

function! airline#extensions#wordcount#init(ext)
  augroup airline_wordcount
    autocmd! User AirlineModeChanged nested
          \ let s:visual = (mode() ==? 'v' || mode() ==? 's')
  augroup END
  call a:ext.add_statusline_func('airline#extensions#wordcount#apply')
endfunction
