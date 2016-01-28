" MIT License. Copyright (c) 2013-2016 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:spc = g:airline_symbols.space

function! airline#extensions#tabline#combined#get()
  let curtabnr = tabpagenr()
  let b = airline#extensions#tabline#new_builder()

  let buffers = tabpagebuflist(curtabnr)
  for nr in buffers
    let group = airline#extensions#tabline#group_of_bufnr(buffers, nr)
    call b.add_section(group, s:spc.'%(%{airline#extensions#tabline#get_buffer_name('.nr.')}%)'.s:spc)
  endfor

  call b.add_section('airline_tabfill', '')
  call b.split()
  call b.add_section('airline_tabfill', '')

  for tabnr in range(1, tabpagenr('$'))
    let group = tabnr == curtabnr ? 'airline_tabtype' : 'airline_tab'
    call b.add_section(group, s:spc . 'tab' . s:spc . tabnr . s:spc . '%' . tabnr . 'X' . 'x' . '%X' . s:spc)
  endfor
  return b.build()
endfunction
