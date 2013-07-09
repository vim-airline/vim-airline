let s:sections = ['a','b','c','gutter','x','y','z']

function! airline#extensions#load()
  let g:unite_force_overwrite_statusline = 0

  if exists('g:loaded_ctrlp') && g:loaded_ctrlp
    call airline#extensions#ctrlp#load_ctrlp_hi()
    let g:ctrlp_status_func = {
          \ 'main': 'airline#extensions#ctrlp#ctrlp_airline',
          \ 'prog': 'airline#extensions#ctrlp#ctrlp_airline_status',
          \ }
  endif
endfunction

function! s:empty_sections()
  for section in s:sections
    let w:airline_section_{section} = ''
  endfor
endfunction

function! airline#extensions#apply_window_overrides()
  for section in s:sections
    silent! unlet w:airline_section_{section}
  endfor

  if &ft == 'netrw'
    let w:airline_section_a = 'netrw'
    let w:airline_section_b = '%f'
    let w:airline_section_c = ''
    let w:airline_section_gutter = ''
    let w:airline_section_x = ''
  elseif &ft == 'unite'
    call s:empty_sections()
    let w:airline_section_a = 'Unite'
    let w:airline_section_b = unite#get_status_string()
  endif
endfunction
