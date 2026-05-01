" MIT License. Copyright (c) 2013-2026 Bailey Ling, Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:parts = {}

" PUBLIC API {{{

function! airline#parts#define(key, config)
  let s:parts[a:key] = get(s:parts, a:key, {})
  if exists('g:airline#init#bootstrapping')
    call extend(s:parts[a:key], a:config, 'keep')
  else
    call extend(s:parts[a:key], a:config, 'force')
  endif
endfunction

function! airline#parts#define_function(key, name)
  call airline#parts#define(a:key, { 'function': a:name })
endfunction

function! airline#parts#define_text(key, text)
  call airline#parts#define(a:key, { 'text': a:text })
endfunction

function! airline#parts#define_raw(key, raw)
  call airline#parts#define(a:key, { 'raw': a:raw })
endfunction

function! airline#parts#define_minwidth(key, width)
  call airline#parts#define(a:key, { 'minwidth': a:width })
endfunction

function! airline#parts#define_condition(key, predicate)
  call airline#parts#define(a:key, { 'condition': a:predicate })
endfunction

function! airline#parts#define_accent(key, accent)
  call airline#parts#define(a:key, { 'accent': a:accent })
endfunction

function! airline#parts#define_empty(keys)
  for key in a:keys
    call airline#parts#define_raw(key, '')
  endfor
endfunction

function! airline#parts#get(key)
  return get(s:parts, a:key, {})
endfunction

" }}}

function! airline#parts#mode()
  let part = airline#parts#get('mode')
  let minwidth = get(part, 'minwidth', 79)
  return airline#util#shorten(get(w:, 'airline_current_mode', ''), minwidth, 1)
endfunction

function! airline#parts#crypt()
  return g:airline_detect_crypt && exists("+key") && !empty(&key) ? g:airline_symbols.crypt : ''
endfunction

function! airline#parts#paste()
  return g:airline_detect_paste && &paste ? g:airline_symbols.paste : ''
endfunction

" Sources:
" https://ftp.nluug.nl/pub/vim/runtime/spell/
" https://en.wikipedia.org/wiki/Regional_indicator_symbol
let s:flags = {
                  \ 'af_za': '🇿🇦[af]',
                  \ 'am_et': '🇭🇺[am]',
                  \ 'bg_bg': '🇧🇬',
                  \ 'br_fr': '🇫🇷[br]',
                  \ 'ca_es': '🇪🇸[ca]',
                  \ 'cs_cz': '🇨🇿',
                  \ 'cy_gb': '🇬🇧[cy]',
                  \ 'da_dk': '🇩🇰',
                  \ 'de'   : '🇩🇪',
                  \ 'de_19': '🇩🇪[19]',
                  \ 'de_20': '🇩🇪[20]',
                  \ 'de_at': '🇩🇪[at]',
                  \ 'de_ch': '🇩🇪[ch]',
                  \ 'de_de': '🇩🇪',
                  \ 'el_gr': '🇬🇷',
                  \ 'en':    '🇬🇧',
                  \ 'en_au': '🇦🇺',
                  \ 'en_ca': '🇨🇦',
                  \ 'en_gb': '🇬🇧',
                  \ 'en_nz': '🇳🇿',
                  \ 'en_us': '🇺🇸',
                  \ 'es':    '🇪🇸',
                  \ 'es_es': '🇪🇸',
                  \ 'es_mx': '🇲🇽',
                  \ 'fo_fo': '🇫🇴',
                  \ 'fr_fr': '🇫🇷',
                  \ 'ga_ie': '🇮🇪',
                  \ 'gd_gb': '🇬🇧[gd]',
                  \ 'gl_es': '🇪🇸[gl]',
                  \ 'he_il': '🇮🇱',
                  \ 'hr_hr': '🇭🇷',
                  \ 'hu_hu': '🇭🇺',
                  \ 'id_id': '🇮🇩',
                  \ 'it_it': '🇮🇹',
                  \ 'ku_tr': '🇹🇷[ku]',
                  \ 'la'   : '🇮🇹[la]',
                  \ 'lt_lt': '🇱🇹',
                  \ 'lv_lv': '🇱🇻',
                  \ 'mg_mg': '🇲🇬',
                  \ 'mi_nz': '🇳🇿[mi]',
                  \ 'ms_my': '🇲🇾',
                  \ 'nb_no': '🇳🇴',
                  \ 'nl_nl': '🇳🇱',
                  \ 'nn_no': '🇳🇴[ny]',
                  \ 'ny_mw': '🇲🇼',
                  \ 'pl_pl': '🇵🇱',
                  \ 'pt':    '🇵🇹',
                  \ 'pt_br': '🇧🇷',
                  \ 'pt_pt': '🇵🇹',
                  \ 'ro_ro': '🇷🇴',
                  \ 'ru'   : '🇷🇺',
                  \ 'ru_ru': '🇷🇺',
                  \ 'ru_yo': '🇷🇺[yo]',
                  \ 'rw_rw': '🇷🇼',
                  \ 'sk_sk': '🇸🇰',
                  \ 'sl_si': '🇸🇮',
                  \ 'sr_rs': '🇷🇸',
                  \ 'sv_se': '🇸🇪',
                  \ 'sw_ke': '🇰🇪',
                  \ 'tet_id': '🇮🇩[tet]',
                  \ 'th'   : '🇹🇭',
                  \ 'tl_ph': '🇵🇭',
                  \ 'tn_za': '🇿🇦[tn]',
                  \ 'uk_ua': '🇺🇦',
                  \ 'yi'   : '🇻🇮',
                  \ 'yi_tr': '🇹🇷',
                  \ 'zu_za': '🇿🇦[zu]',
      \ }
" Also support spelllang without region codes
let s:flags_noregion = {}
for s:key in keys(s:flags)
  let s:flags_noregion[split(s:key, '_')[0]] = s:flags[s:key]
endfor

function! airline#parts#spell()
  let spelllang = g:airline_detect_spelllang ? printf(" [%s]", toupper(substitute(&spelllang, ',', '/', 'g'))) : ''
  if g:airline_detect_spell && (&spell || (exists('g:airline_spell_check_command') && eval(g:airline_spell_check_command)))

    if g:airline_detect_spelllang !=? '0' && g:airline_detect_spelllang ==? 'flag'
      let spelllang = tolower(&spelllang)
      if has_key(s:flags, spelllang)
        return s:flags[spelllang]
      elseif has_key(s:flags_noregion, spelllang)
        return s:flags_noregion[spelllang]
      endif
    endif

    let winwidth = airline#util#winwidth()
    if winwidth >= 90
      return g:airline_symbols.spell . spelllang
    elseif winwidth >= 70
      return g:airline_symbols.spell
    elseif !empty(g:airline_symbols.spell)
      return split(g:airline_symbols.spell, '\zs')[0]
    endif
  endif
  return ''
endfunction

function! airline#parts#iminsert()
  if g:airline_detect_iminsert && &iminsert && exists('b:keymap_name')
    return toupper(b:keymap_name)
  endif
  return ''
endfunction

function! airline#parts#readonly()
  " only consider regular buffers (e.g. ones that represent actual files,
  " but not special ones like e.g. NERDTree)
  if !empty(&buftype) || airline#util#ignore_buf(bufname('%'))
    return ''
  endif
  if &readonly && !filereadable(bufname('%'))
    return '[noperm]'
  else
    return &readonly ? g:airline_symbols.readonly : ''
  endif
endfunction

function! airline#parts#filetype()
  return (airline#util#winwidth() < 90 && strlen(&filetype) > 3)
        \ ? matchstr(&filetype, '...'). (&encoding is? 'utf-8' ? "\u2026" : '>')
        \ : &filetype
endfunction

function! airline#parts#ffenc()
  let expected = get(g:, 'airline#parts#ffenc#skip_expected_string', '')
  let bomb     = &bomb ? '[BOM]' : ''
  let noeolf   = &eol ? '' : '[!EOL]'
  let ff       = strlen(&ff) ? '['.&ff.']' : ''
  if expected is# &fenc.bomb.noeolf.ff
    return ''
  else
    return &fenc.bomb.noeolf.ff
  endif
endfunction

function! airline#parts#executable()
  if exists("*getfperm") && getfperm(bufname('%')) =~ 'x'
    return g:airline_symbols.executable
  else
    return ''
  endif
endfunction

function! airline#parts#gitrepo() abort
  if !exists('*FugitiveFind')
    return expand('%:p')
  endif
  let toplevel = FugitiveFind(':/', bufnr(''))
  if empty(toplevel)
    return expand('%:p')
  endif
  " Remove trailing separator
  let toplevel = substitute(toplevel, '[/\\]$', '', '')
  let reponame = fnamemodify(toplevel, ':t')
  let fullpath = resolve(expand('%:p'))
  " Get file path relative to repo root
  if fullpath[:len(toplevel)-1] ==# toplevel
    let relpath = fullpath[len(toplevel)+1:]
  else
    let relpath = expand('%:t')
  endif
  return reponame .. ':' .. relpath .. (&modified ? '[+]' : '')
endfunction
