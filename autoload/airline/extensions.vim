let s:sections = ['a','b','c','gutter','x','y','z']

function! s:override_left_only(section1, section2)
  let w:airline_section_a = a:section1
  let w:airline_section_b = a:section2
  let w:airline_section_c = ''
  let w:airline_left_only = 1
endfunction

function! airline#extensions#clear_window_overrides()
  silent! unlet w:airline_left_only
  for section in s:sections
    silent! unlet w:airline_section_{section}
  endfor
endfunction

function! airline#extensions#apply_window_overrides()
  if &ft == 'netrw'
    call s:override_left_only('netrw', '%f')
  elseif &ft == 'unite'
    call s:override_left_only('Unite', unite#get_status_string())
  elseif &ft == 'nerdtree'
    call s:override_left_only('NERD', '')
  elseif &ft == 'undotree'
    call s:override_left_only('undotree', '')
  elseif &ft == 'gundo'
    call s:override_left_only('Gundo', '')
  elseif &ft == 'diff'
    call s:override_left_only('diff', '')
  elseif &ft == 'tagbar'
    call s:override_left_only('tagbar', '')
  elseif &ft == 'minibufexpl'
    call s:override_left_only('MiniBufExplorer', '')
  endif
endfunction

function! airline#extensions#load()
  let g:unite_force_overwrite_statusline = 0

  if exists('g:loaded_ctrlp') && g:loaded_ctrlp
    call airline#extensions#ctrlp#load_ctrlp_hi()
    let g:ctrlp_status_func = {
          \ 'main': 'airline#extensions#ctrlp#ctrlp_airline',
          \ 'prog': 'airline#extensions#ctrlp#ctrlp_airline_status',
          \ }
  endif

  call add(g:airline_window_override_funcrefs, function('airline#extensions#apply_window_overrides'))
endfunction

