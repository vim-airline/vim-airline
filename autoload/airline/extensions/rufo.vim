" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('g:rufo_loaded')
  finish
endif

let s:spc = g:airline_symbols.space

if !exists('g:airline#extensions#rufo#symbol')
  let g:airline#extensions#rufo#symbol = 'RuFo'
endif

function! airline#extensions#rufo#init(ext)
   call airline#parts#define_raw('rufo', '%{airline#extensions#rufo#get_status}')
   call a:ext.add_statusline_func('airline#extensions#rufo#apply')
endfunction

function! airline#extensions#rufo#get_status()
  let out = ''
  if &ft == "ruby" && g:rufo_auto_formatting == 1
    let out .= s:spc.g:airline_left_alt_sep.s:spc.g:airline#extensions#rufo#symbol
  endif
  return out
endfunction

" This function will be invoked just prior to the statusline getting modified.
function! airline#extensions#rufo#apply(...)
  " First we check for the filetype.
  if &filetype == "ruby"
    " section_z.
    let w:airline_section_z = get(w:, 'airline_section_z', g:airline_section_z)

    " Then we just append this extension to it, optionally using separators.
    let w:airline_section_z .= '%{airline#extensions#rufo#get_status()}'
  endif
endfunction
