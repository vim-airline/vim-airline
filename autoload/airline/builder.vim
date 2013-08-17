" MIT License. Copyright (c) 2013 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:prototype = {}

function! s:prototype.split(gutter)
  let self._side = 0
  let self._line .= '%#'.self._group(self._curgroup).'#'.a:gutter
endfunction

function! s:prototype.add_section(group, contents)
  if self._curgroup != ''
    call self._highlighter.add_separator(self._group(self._curgroup), self._group(a:group), self._side)
    let self._line .= '%#'.self._group(self._curgroup).'_to_'.self._group(a:group).'#'
    let self._line .= self._side
          \ ? self._active ? g:airline_left_sep : g:airline_left_alt_sep
          \ : self._active ? g:airline_right_sep : g:airline_right_alt_sep
  endif

  let self._line .= '%#'.self._group(a:group).'#'.a:contents
  let self._curgroup = a:group
endfunction

function! s:prototype.add_raw(text)
  let self._line .= a:text
endfunction

function! s:prototype._group(group)
  return self._active ? a:group : a:group.'_inactive'
endfunction

function! s:prototype.build()
  return self._line
endfunction

function! airline#builder#new(active, highlighter)
  let builder = copy(s:prototype)
  let builder._sections = []
  let builder._active = a:active
  let builder._highlighter = a:highlighter
  let builder._side = 1
  let builder._curgroup = ''
  let builder._line = '%{airline#check_mode()}'
  return builder
endfunction

