" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:prototype = {}

function! s:prototype.insert_titles(current, first, last) dict
  let self._first_title = a:first
  let self._last_title = a:last
  let self._left_title = a:current
  let self._right_title = a:current + 1
  let self._left_position = self.get_position()
  let self._right_position = self._left_position
endfunction

function! s:prototype.try_insert_title(index, group, pos, sep_size, force) dict
  let title = self.get_title(a:index)
  let self._remaining_space -= airline#util#strchars(s:evaluate_tabline(title)) + a:sep_size
  if a:force || self._remaining_space >= 0
    let pos = a:pos
    if has_key(self, "get_pretitle")
      call self.insert_raw(self.get_pretitle(a:index), pos)
      let self._right_position += 1
      let pos += 1
    endif

    call self.insert_section(a:group, title, pos)
    let self._right_position += 1
    let pos += 1

    if has_key(self, "get_posttitle")
      call self.insert_raw(self.get_posttitle(a:index), pos)
      let self._right_position += 1
      let pos += 1
    endif

    return 1
  else
    let self._remaining_space += airline#util#strchars(s:evaluate_tabline(title)) + a:sep_size
  endif
  return 0
endfunction

function! s:get_separator_change(new_group, old_group, end_group, sep_size, alt_sep_size)
  let sep_change = 0
  if !empty(a:end_group)
    let sep_change += airline#builder#should_change_group(a:new_group, a:end_group) ? a:sep_size : a:alt_sep_size
  endif
  if !empty(a:old_group)
    let sep_change += airline#builder#should_change_group(a:new_group, a:old_group) ? a:sep_size : a:alt_sep_size
    if !empty(a:end_group)
      let sep_change -= airline#builder#should_change_group(a:old_group, a:end_group) ? a:sep_size : a:alt_sep_size
    endif
  endif
  return sep_change
endfunction

function! s:prototype.build() dict
  if has_key(self, '_left_position')
    let self._remaining_space = &columns - airline#util#strchars(s:evaluate_tabline(self._build()))

    let center_active = get(g:, 'airline#extensions#tabline#center_active', 0)

    let sep_size = airline#util#strchars(s:evaluate_tabline(self._context.left_sep))
    let alt_sep_size = airline#util#strchars(s:evaluate_tabline(self._context.left_alt_sep))

    let overflow_marker = get(g:, 'airline#extensions#tabline#overflow_marker', g:airline_symbols.ellipsis)
    let overflow_marker_size = airline#util#strchars(s:evaluate_tabline(overflow_marker))
    " Allow space for the markers before we begin filling in titles.
    let self._remaining_space -= 2 * overflow_marker_size

    let outer_left_group = airline#builder#get_prev_group(self._sections, self._left_position)
    let outer_right_group = airline#builder#get_next_group(self._sections, self._right_position)

    " Add the current title
    let group = self.get_group(self._left_title)
    let sep_change =
      \ s:get_separator_change(group, "", outer_left_group, sep_size, alt_sep_size) +
      \ s:get_separator_change(group, "", outer_right_group, sep_size, alt_sep_size)
    let left_group = group
    let right_group = group
    let self._left_title -=
      \ self.try_insert_title(self._left_title, group, self._left_position, sep_change, 1)

    if get(g:, 'airline#extensions#tabline#current_first', 0)
      " always have current title first
      let self._left_position += 1
    endif

    " Add the title to the right
    if !center_active && self._right_title <= self._last_title
      let group = self.get_group(self._right_title)
      let sep_change =
        \ s:get_separator_change(group, right_group, outer_right_group, sep_size, alt_sep_size)
      let right_group = group
      let self._right_title +=
      \ self.try_insert_title(self._right_title, group, self._right_position, sep_change, 1)
    endif

    while self._remaining_space > 0
      let done = 0
      if self._left_title >= self._first_title
        let group = self.get_group(self._left_title)
        let sep_change =
          \ s:get_separator_change(group, left_group, outer_left_group, sep_size, alt_sep_size)
        let left_group = group
        let done = self.try_insert_title(self._left_title, group, self._left_position, sep_change, 0)
        let self._left_title -= done
      endif
      if self._right_title <= self._last_title && (center_active || !done)
        let group = self.get_group(self._right_title)
        let sep_change =
          \ s:get_separator_change(group, right_group, outer_right_group, sep_size, alt_sep_size)
        let right_group = group
        let done = self.try_insert_title(self._right_title, group, self._right_position, sep_change, 0)
        let self._right_title += done
      endif
      if !done
        break
      endif
    endwhile

    if self._left_title >= self._first_title
      if get(g:, 'airline#extensions#tabline#current_first', 0)
        let self._left_position -= 1
      endif
      call self.insert_raw('%#'.self.overflow_group.'#'.overflow_marker, self._left_position)
      let self._right_position += 1
    endif

    if self._right_title <= self._last_title
      call self.insert_raw('%#'.self.overflow_group.'#'.overflow_marker, self._right_position)
    endif
  endif

  return self._build()
endfunction

let s:prototype.overflow_group = 'airline_tab'

function! s:evaluate_tabline(tabline)
  let tabline = a:tabline
  let tabline = substitute(tabline, '%{\([^}]\+\)}', '\=eval(submatch(1))', 'g')
  let tabline = substitute(tabline, '%#[^#]\+#', '', 'g')
  let tabline = substitute(tabline, '%(\([^)]\+\)%)', '\1', 'g')
  let tabline = substitute(tabline, '%\d\+[TX]', '', 'g')
  let tabline = substitute(tabline, '%=', '', 'g')
  let tabline = substitute(tabline, '%\d*\*', '', 'g')
  if has('tablineat')
    let tabline = substitute(tabline, '%@[^@]\+@', '', 'g')
  endif
  return tabline
endfunction

function! airline#extensions#tabline#builder#new(context)
  let builder = airline#builder#new(a:context)
  let builder._build = builder.build
  call extend(builder, s:prototype, 'force')
  return builder
endfunction
