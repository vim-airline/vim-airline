" MIT License. Copyright (c) 2013-2014 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

if !exists(':ProjectCreate')
  finish
endif

let s:spc = g:airline_symbols.space

function! airline#extensions#eclim#creat_line(...)
  if &filetype == "tree"
    let builder = a:1
    let s:projets = exists("g:Eclim_project_tree_names") ?
          \ substitute(g:Eclim_project_tree_names, "\|", ", ", "g") :
          \ ""
    if match(g:Eclim_project_tree_names, "\|") == -1
      call builder.add_section('airline_a', s:spc.'Project'.s:spc)
    else
      call builder.add_section('airline_a', s:spc.'Projects'.s:spc)
    endif
    call builder.add_section('airline_b', s:spc.s:projets.s:spc)
    call builder.add_section('airline_c', '')
  return 1
  endif
endfunction

function! airline#extensions#eclim#get_warnings()
  let eclimList = eclim#display#signs#GetExisting()

  if !empty(eclimList)
    " Remove any non-eclim signs (see eclim#display#signs#Update)
    call filter(eclimList, 'v:val.name =~ "^\\(qf_\\)\\?\\(error\\|info\\|warning\\)$"')

    if !empty(eclimList)
      let errorsLine = eclimList[0]['line']
      let errorsNumber = len(eclimList)
      let errors = "[Eclim: line:".string(errorsLine)." (".string(errorsNumber).")]"
      if !exists(':SyntasticCheck') || SyntasticStatuslineFlag() == ''
        return errors.(g:airline_symbols.space)
      endif
    endif
  endif
  return ''
endfunction

function! airline#extensions#eclim#init(ext)
  call airline#parts#define_function('eclim', 'airline#extensions#eclim#get_warnings')
  call a:ext.add_statusline_func('airline#extensions#eclim#creat_line')
endfunction
