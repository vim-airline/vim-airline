" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:prototype = {}

function! s:prototype.insert_tabs(curtab, numtabs) dict
  let self._num_tabs = a:numtabs
  let self._left_tab = a:curtab
  let self._right_tab = a:curtab + 1
  let self._left_position = self.get_position()
  let self._right_position = self._left_position
endfunction

function! s:prototype.try_insert_tab(tab, pos, sep_size, force) dict
  let tab_title = self.get_title(a:tab)
  let self._remaining_space -= s:strchars(s:evaluate_tabline(tab_title)) + a:sep_size
  if a:force || self._remaining_space >= 0
    call self.insert_section(self.get_group(a:tab), tab_title, a:pos)
    let self._right_position += 1
    return 1
  endif
  return 0
endfunction

function! s:prototype.build() dict
  if has_key(self, '_left_position')
    let self._remaining_space = &columns - s:strchars(s:evaluate_tabline(self._build()))

    let left_sep_size = s:strchars(s:evaluate_tabline(self._context.left_sep))
    let left_alt_sep_size = s:strchars(s:evaluate_tabline(self._context.left_alt_sep))

    let skipped_tabs_marker = get(g:, 'airline#extensions#tabline#overflow_marker', g:airline_symbols.ellipsis)
    let skipped_tabs_marker_size = s:strchars(s:evaluate_tabline(skipped_tabs_marker))
    " The left marker will have left_alt_sep, and the right will have left_sep.
    let self._remaining_space -= 2 * skipped_tabs_marker_size + left_sep_size + left_alt_sep_size
    "
    " There are always two left_seps (either side of the selected tab) and all
    " other seperators are left_alt_seps.
    let self._remaining_space -= left_sep_size - left_alt_sep_size

    " Add the current tab
    let self._left_tab -=
      \ self.try_insert_tab(self._left_tab, self._left_position, left_sep_size, 1)

    if get(g:, 'airline#extensions#tabline#current_first', 0)
      " always have current tabpage first
      let self._left_position += 1
    endif

    " Add the tab to the right
    if self._right_tab <= self._num_tabs
      let self._right_tab +=
      \ self.try_insert_tab(self._right_tab, self._right_position, left_alt_sep_size, 1)
    endif

    while self._remaining_space > 0
      if self._left_tab > 0
        let self._left_tab -=
          \ self.try_insert_tab(self._left_tab, self._left_position, left_alt_sep_size, 0)
      elseif self._right_tab <= self._num_tabs
        let self._right_tab +=
          \ self.try_insert_tab(self._right_tab, self._right_position, left_alt_sep_size, 0)
      else
        break
      endif
    endwhile

    if self._left_tab > 0
      if get(g:, 'airline#extensions#tabline#current_first', 0)
        let self._left_position -= 1
      endif
      call self.insert_raw('%#airline_tab#'.skipped_tabs_marker, self._left_position)
      let self._right_position += 1
    endif

    if self._right_tab <= self._num_tabs
      call self.insert_raw('%#airline_tab#'.skipped_tabs_marker, self._right_position)
    endif
  endif

  return self._build()
endfunction

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

" Compatibility wrapper for strchars, in case this vim version does not
" have it natively
function! s:strchars(str)
  if exists('*strchars')
    return strchars(a:str)
  else
    return strlen(substitute(a:str, '.', 'a', 'g'))
  endif
endfunction

function! airline#extensions#tabline#builder#new(context)
  let builder = airline#builder#new(a:context)
  let builder._build = builder.build
  call extend(builder, s:prototype, 'force')
  return builder
endfunction
