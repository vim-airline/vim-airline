" MIT License. Copyright (c) 2017 Thomas Dy
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_denite', 0)
  finish
endif

" Denite does not use vim's built-in modal editing but has a custom prompt
" that implements its own insert/normal mode so we have to handle changing the
" highlight
function! airline#extensions#denite#check_denite_mode(bufnr)
  let l:mode = split(denite#get_status_mode(), ' ')
  let l:mode = tolower(l:mode[1])
  if !exists('b:denite_mode_cache') || l:mode != b:denite_mode_cache
    call airline#highlighter#highlight([l:mode], a:bufnr)
    let b:denite_mode_cache = l:mode
  endif
  return ''
endfunction

function! airline#extensions#denite#apply(...)
  if &ft == 'denite'
    let w:airline_skip_empty_sections = 0
    call a:1.add_section('airline_a', ' Denite %{airline#extensions#denite#check_denite_mode('.a:2['bufnr'].')}')
    call a:1.add_section('airline_c', ' %{denite#get_status_sources()}')
    call a:1.split()
    call a:1.add_section('airline_y', ' %{denite#get_status_path()} ')
    call a:1.add_section('airline_z', ' %{denite#get_status_linenr()} ')
    return 1
  endif
endfunction

function! airline#extensions#denite#init(ext)
  call denite#custom#option('_', 'statusline', 0)
  call a:ext.add_statusline_func('airline#extensions#denite#apply')

  " airline#extensions#denite#apply normally gets called only after the
  " denite window gets closed, so we have to call airline#update_statusline
  " ourselves to make sure it's applied when the window is opened.
  augroup airline_denite
    autocmd!
    autocmd FileType denite call airline#update_statusline()
  augroup END
endfunction

