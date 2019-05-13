" MIT License. Copyright (c) 2017-2019 Thomas Dy et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_denite', 0)
  finish
endif

" Denite does not use vim's built-in modal editing but has a custom prompt
" that implements its own insert/normal mode so we have to handle changing the
" highlight
function! airline#extensions#denite#check_denite_mode(bufnr)
  if &filetype != 'denite'
    return ''
  endif
  if exists('*get_status_mode')
    let denite_ver = 2
  else
    let denite_ver = 3
  endif

  if denite_ver == 3
    let mode = split(denite#get_status("mode"), ' ')
  else
    let mode = split(denite#get_status_mode(), ' ')
  endif
  let mode = tolower(get(mode, 1, ''))
  if !exists('b:denite_mode_cache') || mode != b:denite_mode_cache
    call airline#highlighter#highlight([mode], a:bufnr)
    let b:denite_mode_cache = mode
  endif
  return ''
endfunction

function! airline#extensions#denite#apply(...)
  if &ft == 'denite'

    if exists('*get_status_mode')
      let denite_ver = 2
    else
      let denite_ver = 3
    endif

    let w:airline_skip_empty_sections = 0
    call a:1.add_section('airline_a', ' Denite %{airline#extensions#denite#check_denite_mode('.a:2['bufnr'].')}')
    if denite_ver == 3
      call a:1.add_section('airline_c', ' %{denite#get_status("sources")}')
      call a:1.split()
      call a:1.add_section('airline_y', ' %{denite#get_status("path")} ')
      call a:1.add_section('airline_z', ' %{denite#get_status("linenr")} ')
    else
      call a:1.add_section('airline_c', ' %{denite#get_status_sources()}')
      call a:1.split()
      call a:1.add_section('airline_y', ' %{denite#get_status_path()} ')
      call a:1.add_section('airline_z', ' %{denite#get_status_linenr()} ')
    endif
    return 1
  endif
endfunction

function! airline#extensions#denite#init(ext)
  call denite#custom#option('_', 'statusline', 0)
  call a:ext.add_statusline_func('airline#extensions#denite#apply')
endfunction
