" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:prototype = {}

function! s:prototype.insert_tabs(tabs_position, curtab) dict
  let tab_nr_type = get(g:, 'airline#extensions#tabline#tab_nr_type', 0)
  let num_tabs = tabpagenr('$')
  let left_tab = a:curtab - 1
  let right_tab = a:curtab + 1
  let left_position = a:tabs_position
  let right_position = a:tabs_position + 1
  let remaining_space = &columns - s:strchars(s:evaluate_tabline(self.build()))

  let left_sep_size = s:strchars(s:evaluate_tabline(self._context.left_sep))
  let left_alt_sep_size = s:strchars(s:evaluate_tabline(self._context.left_alt_sep))

  let skipped_tabs_marker = get(g:, 'airline#extensions#tabline#overflow_marker', g:airline_symbols.ellipsis)
  let skipped_tabs_marker_size = s:strchars(s:evaluate_tabline(skipped_tabs_marker))
  " The left marker will have left_alt_sep, and the right will have left_sep.
  let remaining_space -= 2 * skipped_tabs_marker_size + left_sep_size + left_alt_sep_size

  " Add the current tab
  let tab_title = self.get_title(tab_nr_type, a:curtab)
  let remaining_space -= s:strchars(s:evaluate_tabline(tab_title))
  " There are always two left_seps (either side of the selected tab) and all
  " other seperators are left_alt_seps.
  let remaining_space -= 2 * left_sep_size - left_alt_sep_size
  call self.insert_section(self.get_group(a:curtab), tab_title, left_position)

  if get(g:, 'airline#extensions#tabline#current_first', 0)
    " always have current tabpage first
    let left_position += 1
  endif

  " Add the tab to the right
  if right_tab <= num_tabs
    let tab_title = self.get_title(tab_nr_type, right_tab)
    let remaining_space -= s:strchars(s:evaluate_tabline(tab_title)) + left_alt_sep_size
    call self.insert_section(self.get_group(right_tab), tab_title, right_position)
    let right_position += 1
    let right_tab += 1
  endif

  while remaining_space > 0
    if left_tab > 0
      let tab_title = self.get_title(tab_nr_type, left_tab)
      let remaining_space -= s:strchars(s:evaluate_tabline(tab_title)) + left_alt_sep_size
      if remaining_space >= 0
        call self.insert_section(self.get_group(left_tab), tab_title, left_position)
        let right_position += 1
        let left_tab -= 1
      endif
    elseif right_tab <= num_tabs
      let tab_title = self.get_title(tab_nr_type, right_tab)
      let remaining_space -= s:strchars(s:evaluate_tabline(tab_title)) + left_alt_sep_size
      if remaining_space >= 0
        call self.insert_section(self.get_group(right_tab), tab_title, right_position)
        let right_position += 1
        let right_tab += 1
      endif
    else
      break
    endif
  endwhile

  if left_tab > 0
    if get(g:, 'airline#extensions#tabline#current_first', 0)
      let left_position -= 1
    endif
    call self.insert_raw('%#airline_tab#'.skipped_tabs_marker, left_position)
    let right_position += 1
  endif

  if right_tab <= num_tabs
    call self.insert_raw('%#airline_tab#'.skipped_tabs_marker, right_position)
  endif
endfunction

function! s:evaluate_tabline(tabline)
  let tabline = a:tabline
  let tabline = substitute(tabline, '%{\([^}]\+\)}', '\=eval(submatch(1))', 'g')
  let tabline = substitute(tabline, '%#[^#]\+#', '', 'g')
  let tabline = substitute(tabline, '%(\([^)]\+\)%)', '\1', 'g')
  let tabline = substitute(tabline, '%\d\+[TX]', '', 'g')
  let tabline = substitute(tabline, '%=', '', 'g')
  let tabline = substitute(tabline, '%\d*\*', '', 'g')
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
  call extend(builder, s:prototype, 'force')
  return builder
endfunction
