" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#wordcount#formatters#default#format()
  let fmt = get(g:, 'airline#extensions#wordcount#formatter#default#fmt', '%s words')
  let fmt_short = get(g:, 'airline#extensions#wordcount#formatter#default#fmt_short', fmt == '%s words' ? '%sW' : fmt)
  let words = string(s:wordcount())
  if empty(words)
    return
  endif
  let result = g:airline_symbols.space . g:airline_right_alt_sep . g:airline_symbols.space
  if winwidth(0) >= 80
    let separator = s:get_decimal_group()
    if words > 999 && !empty(separator)
      " Format number according to locale, e.g. German: 1.245 or English: 1,245
      let words = substitute(words, '\d\@<=\(\(\d\{3\}\)\+\)$', separator.'&', 'g')
    endif
    let result = printf(fmt, words). result
  else
    let result = printf(fmt_short, words). result
  endif
  return result
endfunction

function! s:wordcount()
  if exists("*wordcount")
    let l:mode = mode()
    if l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# 's' || l:mode ==# 'S'
      let l:visual_words = wordcount()['visual_words']
      if l:visual_words != ''
        return l:visual_words
      else
        return 0
      endif
    else
      return wordcount()['words']
    endif
  elseif mode() =~? 's'
    return
  else
    let old_status = v:statusmsg
    let position = getpos(".")
    exe "silent normal! g\<c-g>"
    let stat = v:statusmsg
    call setpos('.', position)
    let v:statusmsg = old_status

    let parts = split(stat)
    if len(parts) > 11
      return str2nr(parts[11])
    else
      return
    endif
  endif
endfunction

function! s:get_decimal_group()
  if match(get(v:, 'lang', ''), '\v\cC|en') > -1
    return ','
  elseif match(get(v:, 'lang', ''), '\v\cde|dk|fr|pt') > -1
    return '.'
  endif
  return ''
endfunction
