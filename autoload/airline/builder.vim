" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:prototype = {}

function! s:prototype.split(gutter)
  call add(self._sections, ['|', a:gutter])
endfunction

function! s:prototype.add_section(group, contents)
  call add(self._sections, ['airline_'.a:group, a:contents])
endfunction

function! s:prototype.add_raw(text)
  call add(self._sections, ['_', a:text])
endfunction

function! s:prototype._group(group)
  return self._active ? a:group : a:group.'_inactive'
endfunction

function! s:prototype.build()
  let line = '%{airline#check_mode()}'
  let side = 0
  let prev_group = ''
  for section in self._sections
    if section[0] == '|'
      let side = 1
      let line .= '%#'.prev_group.'#'.section[1]
      let prev_group = ''
      continue
    endif
    if section[0] == '_'
      let line .= section[1]
      continue
    endif

    if prev_group != ''
      call self._highlighter.add_separator(self._group(prev_group), self._group(section[0]))
      let line .= side == 0
            \ ? '%#'.self._group(section[0]).'_to_'.self._group(prev_group).'#'
            \ : '%#'.self._group(prev_group).'_to_'.self._group(section[0]).'#'
      let line .= side == 0
            \ ? self._active ? g:airline_left_sep : g:airline_left_alt_sep
            \ : self._active ? g:airline_right_sep : g:airline_right_alt_sep
    endif

    let line .= '%#'.self._group(section[0]).'#'.section[1]
    let prev_group = section[0]
  endfor

  return line
endfunction

function! airline#builder#new(active, highlighter)
  let builder = copy(s:prototype)
  let builder._sections = []
  let builder._active = a:active
  let builder._highlighter = a:highlighter
  return builder
endfunction

