" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html

" for backwards compatibility
if exists('g:airline_detect_whitespace')
  let s:show_message = g:airline_detect_whitespace == 1
else
  let s:show_message = get(g:, 'airline#extensions#whitespace#show_message', 1)
endif

let s:symbol = get(g:, 'airline#extensions#whitespace#symbol',
      \ get(g:, 'airline_whitespace_symbol', get(g:, 'airline_powerline_fonts', 0) ? '✹' : '!'))

let s:checks = get(g:, 'airline#extensions#whitespace#checks', ['indent', 'trailing'])

let s:initialized = 0
let s:enabled = 1

function! airline#extensions#whitespace#check()
  if &readonly || !s:enabled
    return ''
  endif

  if !exists('b:airline_whitespace_check')
    let b:airline_whitespace_check = ''

    let trailing = 0
    if index(s:checks, 'trailing') > -1
      let trailing = search(' $', 'nw')
    endif

    let mixed = 0
    if index(s:checks, 'indent') > -1
      let indents = [search('^ ', 'nb'), search('^ ', 'n'), search('^\t', 'nb'), search('^\t', 'n')]
      let mixed = indents[0] != 0 && indents[1] != 0 && indents[2] != 0 && indents[3] != 0
    endif

    if trailing != 0 || mixed
      let b:airline_whitespace_check = s:symbol." "
      if s:show_message
        if trailing != 0
          let b:airline_whitespace_check .= 'trailing['.trailing.'] '
        endif
        if mixed
          let mixnr = indents[0] == indents[1] ? indents[0] : indents[2]
          let b:airline_whitespace_check .= 'mixed-indent['.mixnr.'] '
        endif
      endif
    endif
  endif
  return b:airline_whitespace_check
endfunction!

function! airline#extensions#whitespace#apply(...)
  if !exists('w:airline_section_warning')
    let w:airline_section_warning = ' '
  endif
  let w:airline_section_warning .= '%{airline#extensions#whitespace#check()}'
endfunction

function! airline#extensions#whitespace#toggle()
  if s:enabled
    autocmd! airline_whitespace CursorHold,BufWritePost
    let s:enabled = 0
  else
    call airline#extensions#whitespace#init()
    let s:enabled = 1
  endif
endfunction

function! airline#extensions#whitespace#init(...)
  if !s:initialized
    let s:initialized = 1
    call airline#add_statusline_func('airline#extensions#whitespace#apply')
  endif

  unlet! b:airline_whitespace_check
  augroup airline_whitespace
    autocmd!
    autocmd CursorHold,BufWritePost * unlet! b:airline_whitespace_check
  augroup END
endfunction

