" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:formatter = get(g:, 'airline#extensions#wordcount#formatter', 'default')
let g:airline#extensions#wordcount#filetypes = get(g:, 'airline#extensions#wordcount#filetypes',
      \ '\vhelp|markdown|rst|org|text|asciidoc|tex|mail')

function! s:wordcount_update()
  if empty(bufname(''))
    return
  endif
  if match(&ft, get(g:, 'airline#extensions#wordcount#filetypes')) > -1
    let l:mode = mode()
    if l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# 's' || l:mode ==# 'S'
      let b:airline_wordcount = airline#extensions#wordcount#formatters#{s:formatter}#format()
      let b:airline_change_tick = b:changedtick
    else
      if get(b:, 'airline_wordcount_cache', '') is# '' ||
            \ b:airline_wordcount_cache isnot# get(b:, 'airline_wordcount', '') ||
            \ get(b:, 'airline_change_tick', 0) != b:changedtick || 
            \ get(b:, 'airline_winwidth', 0) != winwidth(0)
        " cache data
        let b:airline_wordcount = airline#extensions#wordcount#formatters#{s:formatter}#format()
        let b:airline_wordcount_cache = b:airline_wordcount
        let b:airline_change_tick = b:changedtick
        let b:airline_winwidth = winwidth(0)
      endif
    endif
  endif
endfunction

function! airline#extensions#wordcount#apply(...)
  if match(&ft, get(g:, 'airline#extensions#wordcount#filetypes')) > -1
    call airline#extensions#prepend_to_section('z', '%{get(b:, "airline_wordcount", "")}')
  endif
endfunction

function! airline#extensions#wordcount#init(ext)
  call a:ext.add_statusline_func('airline#extensions#wordcount#apply')
  autocmd BufReadPost,CursorMoved,CursorMovedI * call s:wordcount_update()
endfunction
