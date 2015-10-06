" MIT License. Copyright (c) 2013-2015 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let g:airline#extensions#wordcount#filetypes = '\vhelp|markdown|rst|org'

" http://stackoverflow.com/questions/114431/fast-word-count-function-in-vim
function! airline#extensions#wordcount#count()
  let old_status = v:statusmsg
  let position = getpos(".")
  exe "silent normal g\<c-g>"
  let txt = ''
  let stat = v:statusmsg
  if stat != '--No lines in buffer--'
    let parts = split(v:statusmsg)
    if len(parts) > 11
      let cnt = str2nr(split(v:statusmsg)[11])
      let spc = g:airline_symbols.space
      let txt = cnt . spc . 'words' . spc . g:airline_right_alt_sep . spc
    endif
  end
  call setpos('.', position)
  let v:statusmsg = old_status
  return txt
endfunction

function! airline#extensions#wordcount#apply(...)
  if &ft =~ g:airline#extensions#wordcount#filetypes
    call airline#extensions#prepend_to_section('z', '%{airline#extensions#wordcount#count()}')
  endif
endfunction

function! airline#extensions#wordcount#init(ext)
  call a:ext.add_statusline_func('airline#extensions#wordcount#apply')
endfunction

