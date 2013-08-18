" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#hunks#get_hunks()
  try
    " throws an error when first entering a buffer, so we gotta swallow it
    silent! let hunks = GitGutterGetHunks()
    let added = 0
    let removed = 0
    let changed = 0
    for hunk in hunks
      let diff = hunk[3] - hunk[1]
      if diff > 0
        let added += diff
      elseif diff < 0
        let removed -= diff
      else
        let changed += 1
      endif
    endfor
    return printf('+%s ~%s -%s', added, changed, removed)
  catch
    return ''
  endtry
  return ''
endfunction

function! airline#extensions#hunks#init(ext)
  let g:airline_section_b .= '%{airline#extensions#hunks#get_hunks()} '
endfunction

