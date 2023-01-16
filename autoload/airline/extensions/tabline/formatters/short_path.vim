" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#short_path#format(bufnr, buffers)
  let fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':p:h:t')
  let _ = ''

  let name = bufname(a:bufnr)
  if empty(name)
    let _ .= '[No Name]'
  elseif name =~ 'term://'
    " Neovim Terminal
    let _ = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
  else
    let _ .= fnamemodify(name, fmod) . '/' . fnamemodify(name, ':t')
  endif

  return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, _)
endfunction
