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
    " 11 - words, 5 - visual words (in visual mode)
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
  return airline#extensions#wordcount#formatters#{s:formatter}#transform(
        \ s:get_wordcount(a:type))
endfunction

" check user-defined formatter exists and has appropriate functions, otherwise
" fall back to default
if s:formatter !=# 'default'
  execute 'runtime! autoload/airline/extensions/wordcount/formatters/'.s:formatter
  if !exists('*airline#extensions#wordcount#formatters#{s:formatter}#transform')
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
function! s:wordcount_update()
  if empty(bufname(''))
    return
  endif
  if match(&ft, get(g:, 'airline#extensions#wordcount#filetypes')) > -1
    let l:mode = mode()
    if l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# 's' || l:mode ==# 'S'
      let b:airline_wordcount = s:format_wordcount('visual_words')
      let b:airline_change_tick = b:changedtick
    else
      if get(b:, 'airline_wordcount_cache', '') is# '' ||
            \ b:airline_wordcount_cache isnot# get(b:, 'airline_wordcount', '') ||
            \ get(b:, 'airline_change_tick', 0) != b:changedtick || 
            \ get(b:, 'airline_winwidth', 0) != winwidth(0)
        " cache data
        let b:airline_wordcount = s:format_wordcount('words')
        let b:airline_wordcount_cache = b:airline_wordcount
        let b:airline_change_tick = b:changedtick
        let b:airline_winwidth = winwidth(0)
      endif
    endif
  endif
endfunction

" autocmds & airline functions {{{1
" default filetypes
let g:airline#extensions#wordcount#filetypes = get(g:, 'airline#extensions#wordcount#filetypes',
      \ '\vhelp|markdown|rst|org|text|asciidoc|tex|mail')

function! airline#extensions#wordcount#apply(...)
  if match(&ft, get(g:, 'airline#extensions#wordcount#filetypes')) > -1
    call airline#extensions#prepend_to_section('z', '%{get(b:, "airline_wordcount", "")}')
  endif
endfunction

function! airline#extensions#wordcount#init(ext)
  call a:ext.add_statusline_func('airline#extensions#wordcount#apply')
  autocmd BufReadPost,CursorMoved,CursorMovedI * call s:wordcount_update()
endfunction
