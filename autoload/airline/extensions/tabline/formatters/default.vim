" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2 et

scriptencoding utf-8

if !exists(":def") || !airline#util#has_vim9_script()
  function! airline#extensions#tabline#formatters#default#format(bufnr, buffers)
    let fnametruncate = get(g:, 'airline#extensions#tabline#fnametruncate', 0)
    let fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':~:.')
    let _ = ''

    let name = bufname(a:bufnr)
    if empty(name)
      let _ = '[No Name]'
    elseif name =~ 'term://'
      " Neovim Terminal
      let _ = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
    else
      if get(g:, 'airline#extensions#tabline#fnamecollapse', 1)
        " Does not handle non-ascii characters like Cyrillic: 'D/Учёба/t.c'
        "let _ .= substitute(fnamemodify(name, fmod), '\v\w\zs.{-}\ze(\\|/)', '', 'g')
        let _ = pathshorten(fnamemodify(name, fmod))
      else
        let _ = fnamemodify(name, fmod)
      endif
      if a:bufnr != bufnr('%') && fnametruncate && strlen(_) > fnametruncate
        let _ = airline#util#strcharpart(_, 0, fnametruncate)
      endif
    endif

    return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, _)
  endfunction

  function! airline#extensions#tabline#formatters#default#wrap_name(bufnr, buffer_name)
    let buf_nr_format = get(g:, 'airline#extensions#tabline#buffer_nr_format', '%s: ')
    let buf_nr_show = get(g:, 'airline#extensions#tabline#buffer_nr_show', 0)

    let _ = buf_nr_show ? printf(buf_nr_format, a:bufnr) : ''
    let _ .= substitute(a:buffer_name, '\\', '/', 'g')

    if getbufvar(a:bufnr, '&modified') == 1
      let _ .= g:airline_symbols.modified
    endif
    return _
  endfunction
  finish
else
  " Vim9 Script implementation
  def airline#extensions#tabline#formatters#default#format(bufnr: number, buffers: list<number>): string
		var fnametruncate = get(g:, 'airline#extensions#tabline#fnametruncate', 0)
    var fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':~:.')
    var result = ''

    var name = bufname(bufnr)
    if empty(name)
      result = '[No Name]'
    elseif name =~ 'term://'
      # Neovim Terminal
      result = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
    else
      if get(g:, 'airline#extensions#tabline#fnamecollapse', 1)
         result = pathshorten(fnamemodify(name, fmod))
      else
         result = fnamemodify(name, fmod)
      endif
      if bufnr != bufnr('%') && fnametruncate && strlen(result) > fnametruncate
        result = airline#util#strcharpart(result, 0, fnametruncate)
      endif
    endif
    return airline#extensions#tabline#formatters#default#wrap_name(bufnr, result)
  enddef

  def airline#extensions#tabline#formatters#default#wrap_name(bufnr: number, buffer_name: string): string
    var buf_nr_format = get(g:, 'airline#extensions#tabline#buffer_nr_format', '%s: ')
    var buf_nr_show = get(g:, 'airline#extensions#tabline#buffer_nr_show', 0)

    var result = buf_nr_show ? printf(buf_nr_format, bufnr) : ''
    result ..= substitute(buffer_name, '\\', '/', 'g')

    if getbufvar(bufnr, '&modified') == 1
      result ..= g:airline_symbols.modified
    endif
    return result
  enddef
endif
