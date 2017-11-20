" MIT License. Copyright (c) 2016 Jerome Reybert
" vim: et ts=2 sts=2 sw=2

" This plugin replace the whole section_a when in vimagit buffer
scriptencoding utf-8

if !get(g:, 'loaded_magit', 0)
  finish
endif

function! airline#extensions#vimagit#init(ext)
  call a:ext.add_statusline_func('airline#extensions#vimagit#apply')
endfunction

function! airline#extensions#vimagit#get_mode()
  if ( exists("*magit#get_current_mode") )
    return magit#get_current_mode()
  else
    if ( b:magit_current_commit_mode == '' )
      return "STAGING"
    elseif ( b:magit_current_commit_mode == 'CC' )
      return "COMMIT"
    elseif ( b:magit_current_commit_mode == 'CA' )
      return "AMEND"
    else
      return "???"
    endif
endfunction

function! airline#extensions#vimagit#apply(...)
  if ( &filetype == 'magit' )
    let w:airline_section_a = '%{airline#extensions#vimagit#get_mode()}'
  endif
endfunction
