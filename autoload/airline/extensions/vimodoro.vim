" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/VimfanTPdvorak/vimodoro.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':RTM')
  finish
endif

function! airline#extensions#vimodoro#apply(...) abort
  if exists('t:vimodoro')
    if &ft ==# 'vimodoro'
        if exists(':PomodoroStatus')
          call airline#extensions#apply_left_override('vimodoro', '%{PomodoroStatus(1)}')
        else
          call airline#extensions#apply_left_override('vimodoro', g:airline_section_y)
        endif
    endif
  endif
endfunction

function! airline#extensions#vimodoro#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#vimodoro#apply')
endfunction
