" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

call airline#parts#define_function('tmode', 'airline#extensions#term#termmode')
call airline#parts#define('terminal', {'text': get(g:airline_mode_map, 't', 't'), 'accent': 'bold'})


function! s:GetAirlineSection()
  if exists("g:airline_section_z_term")
    let section_z = g:airline_section_z_term
  else
    let section_z = airline#section#create(['linenr', 'maxlinenr'])
  endif

  if exists("g:airline_section_a_term")
    let section_a = g:airline_section_a_term
  else
    let section_a = airline#section#create_left(['terminal', 'tmode'])
  endif
  return [section_a, section_z]
endfunction

function! airline#extensions#term#apply(...) abort
  if &buftype ==? 'terminal' || bufname(a:2.bufnr)[0] ==? '!'
    let sections = s:GetAirlineSection()
    let spc = g:airline_symbols.space
    call a:1.add_section_spaced('airline_a', sections[0])
    call a:1.add_section_spaced('airline_b', s:neoterm_id(a:2.bufnr))
    call a:1.add_section('airline_term', spc.s:termname(a:2.bufnr))
    call a:1.split()
    call a:1.add_section('airline_y', '')
    call a:1.add_section_spaced('airline_z', sections[1])
    return 1
  endif
endfunction

function! airline#extensions#term#inactive_apply(...) abort
  if getbufvar(a:2.bufnr, '&buftype') ==? 'terminal'
    let sections = s:GetAirlineSection()
    let spc = g:airline_symbols.space
    call a:1.add_section_spaced('airline_a', sections[0])
    call a:1.add_section_spaced('airline_b', s:neoterm_id(a:2.bufnr))
    call a:1.add_section('airline_term', spc.s:termname(a:2.bufnr))
    call a:1.split()
    call a:1.add_section('airline_y', '')
    call a:1.add_section_spaced('airline_z', sections[1])
    return 1
  endif
endfunction

function! airline#extensions#term#termmode() abort
  let mode = airline#parts#mode()[0]
  if mode ==? 'T' || mode ==? '-'
    " We don't need to output T, the statusline already says "TERMINAL".
    " Also we don't want to output "-" on an inactive statusline.
    let mode = ''
  endif
  return mode
endfunction

function! s:termname(bufnr) abort
  let bufname = bufname(a:bufnr)
  if has('nvim')
    " Get rid of the leading "term", working dir and process ID.
    " Afterwards, remove the possibly added neoterm ID.
    return substitute(matchstr(bufname, 'term.*:\zs.*'),
                    \ ';#neoterm-\d\+', '', '')
  else
    if bufname =~? 'neoterm-\d\+'
      " Do not return a redundant buffer name, when this is a neoterm terminal.
      return ''
    endif
    " Get rid of the leading "!".
    if bufname[0] ==? '!'
      return bufname[1:]
    else
      return bufname
    endif
  endif
endfunction

function! s:neoterm_id(bufnr) abort
  let id = getbufvar(a:bufnr, 'neoterm_id')
  if id !=? ''
    let id = 'neoterm-'.id
  endif
  return id
endfunction

function! airline#extensions#term#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#term#apply')
  call a:ext.add_inactive_statusline_func('airline#extensions#term#inactive_apply')
endfunction
