" MIT License. Copyright (c) 2013-2014 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:prototype = {}

function! s:prototype.split(...)
  call add(self._sections, ['|', a:0 ? a:1 : '%='])
endfunction

function! s:prototype.add_section_spaced(group, contents)
  call self.add_section(a:group, (g:airline_symbols.space).a:contents.(g:airline_symbols.space))
endfunction

function! s:prototype.add_section(group, contents)
  call add(self._sections, [a:group, a:contents])
endfunction

function! s:prototype.add_raw(text)
  call add(self._sections, ['', a:text])
endfunction

function! s:prototype.build()
  let side = 1
  let prev_group = ''
  let line = ''

  for section in self._sections
    let group = section[0]
    let contents = section[1]

    if group == '|'
      let side = 0
      let line .= contents
      continue
    endif

    if prev_group != ''
      if prev_group == group
        let line .= side ? self._context.left_alt_sep : self._context.right_alt_sep
      elseif group != ''
        call airline#highlighter#add_separator(prev_group, group, side)
        let line .= '%#'.prev_group.'_to_'.group.'#'
        let line .= side ? self._context.left_sep : self._context.right_sep
      endif
    endif

    if group != prev_group
      let line .= '%#'.group.'#'
    endif
    let line .= s:get_accented_line(self, group, contents)

    if group != ''
      let prev_group = group
    endif
  endfor

  if !self._context.active
    let line = substitute(line, '%#.\{-}\ze#', '\0_inactive', 'g')
  endif
  return line
endfunction

function! s:get_accented_line(self, group, contents)
  if a:self._context.active
    let contents = []
    let content_parts = split(a:contents, '__accent')
    for cpart in content_parts
      let accent = matchstr(cpart, '_\zs[^#]*\ze')
      call add(contents, cpart)
    endfor
    let line = join(contents, a:group)
    let line = substitute(line, '__restore__', a:group, 'g')
  else
    let line = substitute(a:contents, '%#__accent[^#]*#', '', 'g')
    let line = substitute(line, '%#__restore__#', '', 'g')
  endif
  return line
endfunction

function! airline#builder#new(context)
  let builder = copy(s:prototype)
  let builder._context = a:context
  let builder._sections = []

  call extend(builder._context, {
        \ 'left_sep': g:airline_left_sep,
        \ 'left_alt_sep': g:airline_left_alt_sep,
        \ 'right_sep': g:airline_right_sep,
        \ 'right_alt_sep': g:airline_right_alt_sep,
        \ }, 'keep')
  return builder
endfunction

