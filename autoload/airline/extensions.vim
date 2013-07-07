function! airline#extensions#load()
  let g:unite_force_overwrite_statusline = 0
  autocmd FileType unite
        \ let w:airline_section_a = 'Unite'
        \ | let w:airline_section_b = unite#get_status_string()
        \ | call airline#update_statusline(1)
        \ | unlet w:airline_section_a | unlet w:airline_section_b

  if exists('g:loaded_ctrlp') && g:loaded_ctrlp
    call airline#extensions#ctrlp#load_ctrlp_hi()
    let g:ctrlp_status_func = {
          \ 'main': 'airline#extensions#ctrlp#ctrlp_airline',
          \ 'prog': 'airline#extensions#ctrlp#ctrlp_airline_status',
          \ }
  endif
endfunction
