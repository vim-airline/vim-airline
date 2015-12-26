" MIT License. Copyright (c) 2013-2015 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:spc = g:airline_symbols.space

let s:filetypes = get(g:, 'airline#extensions#wordcount#filetypes', '\vhelp|markdown|rst|org')
let s:format = get(g:, 'airline#extensions#wordcount#format', '%d'.s:spc.'words')

" adapted from http://stackoverflow.com/questions/114431/fast-word-count-function-in-vim
function! airline#extensions#wordcount#get_wordcount()
  let l:old_status = v:statusmsg
  let l:position = getpos(".")
  exe "silent normal! g\<c-g>"
  let l:stat = v:statusmsg
  call setpos('.', l:position)
  let v:statusmsg = l:old_status

  let l:parts = split(l:stat)
  let l:res = ''
  if len(l:parts) > 11
    let l:cnt = str2nr(split(stat)[11])
    try
      let l:res = printf(s:format, cnt).s:spc
    catch /^Vim\%((\a\+)\)\=:E767/
      " printf: wrong format
      let l:res = ''
    endtry
  endif
  return l:res
endfunction

function! airline#extensions#wordcount#init(ext)
  call airline#parts#define_function('wordcount', 'airline#extensions#wordcount#get_wordcount')
  call airline#parts#define_condition('wordcount', "(&filetype =~ '" . s:filetypes . "')")
endfunction

