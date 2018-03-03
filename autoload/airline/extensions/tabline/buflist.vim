" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#buflist#invalidate()
  unlet! s:current_buffer_list
endfunction

function! airline#extensions#tabline#buflist#list()
  if exists('s:current_buffer_list')
    return s:current_buffer_list
  endif

  let s:exclude_buffers = get(g:, 'airline#extensions#tabline#exclude_buffers', [])
  let s:exclude_paths = get(g:, 'airline#extensions#tabline#excludes', [])
  let s:exclude_preview = get(g:, 'airline#extensions#tabline#exclude_preview', 1)

  let list = (exists('g:did_bufmru') && g:did_bufmru) ? BufMRUList() : range(1, bufnr("$"))

  " paths in excludes list
  fun! s:ExcludePaths(nr)
    let bpath = fnamemodify(bufname(a:nr), ":p")
    for f in s:exclude_paths
      if bpath =~# f | return 1 | endif
    endfor
  endfun

  " other types to exclude
  fun! s:ExcludeOther(nr)
    if (getbufvar(a:nr, 'current_syntax') == 'qf') ||
          \  (s:exclude_preview && getbufvar(a:nr, '&bufhidden') == 'wipe'
          \  && getbufvar(a:nr, '&buftype') == 'nofile')
      return 1 | endif
  endfun

  let buffers = []
  " If this is too slow, we can switch to a different algorithm.
  " Basically branch 535 already does it, but since it relies on
  " BufAdd autocommand, I'd like to avoid this if possible.
  for nr in list
    if buflisted(nr)
      " Do not add to the bufferlist, if either
      " 1) bufnr is exclude_buffers list
      " 2) buffername matches one of exclude_paths patterns
      " 3) buffer is a quickfix buffer
      " 4) when excluding preview windows:
      "     'bufhidden' == wipe
      "     'buftype' == nofile

      " check buffer numbers first
      if index(s:exclude_buffers, nr) >= 0
        continue
        " check paths second
      elseif !empty(s:exclude_paths) && s:ExcludePaths(nr)
        continue
        " check other types last
      elseif s:ExcludeOther(nr)
        continue
      endif

      call add(buffers, nr)
    endif
  endfor

  let s:current_buffer_list = buffers
  return buffers
endfunction
