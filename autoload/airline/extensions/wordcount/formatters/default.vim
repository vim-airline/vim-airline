" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:fmt = get(g:, 'airline#extensions#wordcount#formatter#default#fmt', '%s words')
let s:fmt_short = get(g:, 'airline#extensions#wordcount#formatter#default#fmt_short', s:fmt == '%s words' ? '%sW' : s:fmt)

function! airline#extensions#wordcount#formatters#default#transform(text)
  if empty(a:text)
    return
  endif

  let result = g:airline_symbols.space . g:airline_right_alt_sep . g:airline_symbols.space
  if winwidth(0) >= 80
    let separator = s:get_decimal_group()
    if a:text > 999 && !empty(separator)
      " Format number according to locale, e.g. German: 1.245 or English: 1,245
      let text = substitute(a:text, '\d\@<=\(\(\d\{3\}\)\+\)$', separator.'&', 'g')
    else
      let text = a:text
    endif
    let result = printf(s:fmt, a:text). result
  else
    let result = printf(s:fmt_short, a:text). result
  endif
  return result
endfunction

function! s:get_decimal_group()
  if match(get(v:, 'lang', ''), '\v\cC|en') > -1
    return ','
  elseif match(get(v:, 'lang', ''), '\v\cde|dk|fr|pt') > -1
    return '.'
  endif
  return ''
endfunction

