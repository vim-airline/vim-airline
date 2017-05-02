" vim: et ts=2 sts=2 sw=2

if !exists(':Tnew')
  finish
endif

let g:neoterm_test_status = {'running': '🏃','success': '💚','failed': '💔'}
let g:neoterm_test_status_format = '%s'

function! AirlineNeotermSpecStatus()
 return printf('%s', g:neoterm_statusline )
endfunction

function! airline#extensions#neoterm#init(ext)
  call airline#parts#define_function(
        \ 'neoterm_test_status',
        \ 'AirlineNeotermSpecStatus'
        \)
endfunction
