function! airline#extensions#load()
  if exists('g:loaded_ctrlp') && g:loaded_ctrlp
    call airline#extensions#ctrlp#load_ctrlp_hi()
    let g:ctrlp_status_func = {
          \ 'main': 'airline#extensions#ctrlp#ctrlp_airline',
          \ 'prog': 'airline#extensions#ctrlp#ctrlp_airline_status',
          \ }
  endif
endfunction
