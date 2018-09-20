" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2 fdm=marker

scriptencoding utf-8

" get wordcount {{{1
if exists('*wordcount')
  function! s:get_wordcount(visual_mode_active)
    let query = a:visual_mode_active ? 'visual_words' : 'words'
    return string(wordcount()[query])
  endfunction
else
  function! s:get_wordcount(visual_mode_active)
    " index to retrieve from whitespace-separated output of g_CTRL-G
    " 11 : words, 5 : visual words (in visual mode)
    let idx = a:visual_mode_active ? 5 : 11

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
function! s:format_wordcount(wordcount)
  return airline#extensions#wordcount#formatters#{s:formatter}#to_string(a:wordcount)
endfunction

" check user-defined formatter exists with appropriate functions, otherwise
" fall back to default
if s:formatter !=# 'default'
  execute 'runtime! autoload/airline/extensions/wordcount/formatters/'.s:formatter
  if !exists('*airline#extensions#wordcount#formatters#{s:formatter}#to_string')
    if !exists('*airline#extensions#wordcount#formatters#{s:formatter}#format')
      let s:formatter = 'default'
    else
      " redefine for backwords compatibility
      function! s:format_wordcount(_)
        if mode() ==? 'v'
          return b:airline_wordcount
        else
          return airline#extensions#wordcount#formatters#{s:formatter}#format()
        endif
      endfunction
    endif
  endif
endif

" update {{{1
let s:wordcount_cache = 0  " cache wordcount for performance when force_update=0
function! s:update_wordcount(force_update)
  let wordcount = s:get_wordcount(0)
  if wordcount != s:wordcount_cache || a:force_update
    let s:wordcount_cache = wordcount
    let b:airline_wordcount =  s:format_wordcount(wordcount)
  endif
endfunction

let s:visual_active = 0  " Boolean: for when to get visual wordcount
function airline#extensions#wordcount#get()
  if s:visual_active
    return s:format_wordcount(s:get_wordcount(1))
  else
    if b:airline_changedtick != b:changedtick
      call s:update_wordcount(0)
      let b:airline_changedtick = b:changedtick
    endif
    return b:airline_wordcount
  endif
endfunction

" airline functions {{{1
" default filetypes:
let s:filetypes = ['help', 'markdown', 'rst', 'org', 'text', 'asciidoc', 'tex', 'mail']
function! airline#extensions#wordcount#apply(...)
  let filetypes = get(g:, 'airline#extensions#wordcount#filetypes', s:filetypes)

  " Check if filetype needs testing
  if did_filetype() || filetypes isnot s:filetypes
    let s:filetypes = filetypes

    " Select test based on type of "filetypes": new=list, old=string
    if type(filetypes) == get(v:, 't_list', type([]))
          \ ? index(filetypes, &filetype) > -1 || index(filetypes, 'all') > -1
          \ : match(&filetype, filetypes) > -1
      let b:airline_changedtick = -1
      call s:update_wordcount(1) " force update: ensures initial worcount exists
    elseif exists('b:airline_wordcount') " cleanup when filetype is removed
      unlet b:airline_wordcount
    endif
  endif

  if exists('b:airline_wordcount')
    call airline#extensions#prepend_to_section(
          \ 'z', '%{airline#extensions#wordcount#get()}')
  endif
endfunction

function! airline#extensions#wordcount#init(ext)
  augroup airline_wordcount
    autocmd! User AirlineModeChanged nested
          \ let s:visual_active = (mode() ==? 'v' || mode() ==? 's')
  augroup END
  call a:ext.add_statusline_func('airline#extensions#wordcount#apply')
endfunction
