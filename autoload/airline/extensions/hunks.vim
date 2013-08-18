" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

function! airline#extensions#hunks#get_hunks()
  if get(g:, 'gitgutter_initialised', 0) && get(g:, 'gitgutter_enabled', 0)
    let added = 0
    let removed = 0
    let changed = 0
    let hunks = GitGutterGetHunks()
    for hunk in hunks
      if hunk[1] == 0 && hunk[3] > 0
        let added += hunk[3]
      elseif hunk[1] > 0 && hunk[3] == 0
        let removed += hunk[1]
      elseif hunk[1] > 0 && hunk[3] > 0
        if hunk[1] == hunk[3]
          let changed += hunk[3]
        elseif hunk[1] < hunk[3]
          let changed += hunk[1]
          let added += (hunk[3] - hunk[1])
        elseif hunk[1] > hunk[3]
          let changed += hunk[3]
          let removed += (hunk[1] - hunk[3])
        endif
      endif
    endfor
    return printf('+%s ~%s -%s ', added, changed, removed)
  endif
  return ''
endfunction

function! airline#extensions#hunks#init(ext)
  let g:airline_section_b .= '%{airline#extensions#hunks#get_hunks()}'
endfunction

