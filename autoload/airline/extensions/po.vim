" MIT License. Copyright (c) 2013-2016 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:has_async = airline#util#async

function! s:shorten()
  if exists("g:airline#extensions#po#displayed_limit")
    let w:displayed_po_limit = g:airline#extensions#po#displayed_limit
    if len(b:airline_po_stats) > w:displayed_po_limit - 1
      let b:airline_po_stats = b:airline_po_stats[0:(w:displayed_po_limit - 2)].(&encoding==?'utf-8' ? '…' : '.'). ']'
    endif
  endif
endfunction

if s:has_async
  let s:jobs = {}

  function! s:on_stdout(channel, msg) dict abort
    let self.buf = a:msg
  endfunction

  function! s:on_exit(channel) dict abort
    if !empty(self.buf)
      let b:airline_po_stats = printf("[%s]", self.buf)
    else
      let b:airline_po_stats = ''
    endif
    call remove(s:jobs, self.file)
    call s:shorten()
  endfunction

  function! s:get_msgfmt_stat_async(cmd, file)
    if g:airline#util#is_windows || !executable('msgfmt')
      " no msgfmt on windows?
      return
    else
      let cmd = ['sh', '-c', a:cmd. shellescape(a:file)]
    endif

    let options = {'buf': '', 'file': a:file}
    if has_key(s:jobs, a:file)
      if job_status(get(s:jobs, a:file)) == 'run'
        return
      elseif has_key(s:jobs, a:file)
        call remove(s:jobs, a:file)
      endif
    endif
    let id = job_start(cmd, {
          \ 'err_io':   'out',
          \ 'out_cb':   function('s:on_stdout', options),
          \ 'close_cb': function('s:on_exit', options)})
    let s:jobs[a:file] = id
  endfu
endif

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
  if s:has_async
    call s:get_msgfmt_stat_async(cmd, expand('%:p'))
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
    call s:shorten()
  endif
  return get(b:, 'airline_po_stats', '')
endfunction

function! airline#extensions#po#init(ext)
    call a:ext.add_statusline_func('airline#extensions#po#apply')
endfunction
