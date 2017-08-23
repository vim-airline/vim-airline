" MIT License. Copyright (c) 2013-2016 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#po#shorten()
  if exists("g:airline#extensions#po#displayed_limit")
    let w:displayed_po_limit = g:airline#extensions#po#displayed_limit
    if len(b:airline_po_stats) > w:displayed_po_limit - 1
      let b:airline_po_stats = b:airline_po_stats[0:(w:displayed_po_limit - 2)].(&encoding==?'utf-8' ? '…' : '.'). ']'
    endif
  endif
endfunction

function! airline#extensions#po#apply(...)
  if &ft ==# 'po'
    call airline#extensions#prepend_to_section('z', '%{airline#extensions#po#stats()}')
    autocmd airline BufWritePost * unlet! b:airline_po_stats
  endif
endfunction

function! airline#extensions#po#stats()
  if exists('b:airline_po_stats') && !empty(b:airline_po_stats)
    return b:airline_po_stats
  endif

  let cmd = 'msgfmt --statistics -o /dev/null -- '
  if g:airline#init#vim_async
    call airline#async#get_msgfmt_stat(cmd, expand('%:p'))
  elseif has("nvim")
    call airline#async#nvim_get_msgfmt_stat(cmd, expand('%:p'))
  else
    let airline_po_stats = system(cmd. shellescape(expand('%:p')))
    if v:shell_error
      return ''
    endif
    try
      let b:airline_po_stats = '['. split(airline_po_stats, '\n')[0]. ']'
      let b:airline_po_stats = substitute(b:airline_po_stats, ' \(message\|translation\)s*\.*', '', 'g')
    catch
      let b:airline_po_stats = ''
    endtry
    call airline#extensions#po#shorten()
  endif
  return get(b:, 'airline_po_stats', '')
endfunction

function! airline#extensions#po#init(ext)
    call a:ext.add_statusline_func('airline#extensions#po#apply')
endfunction
