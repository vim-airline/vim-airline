" powerline symbols:       
" some unicode symbols: ▶ » « ◀
if !exists('g:airline_left_sep')
  let g:airline_left_sep=exists('g:airline_powerline_fonts')?"":">"
endif
if !exists('g:airline_right_sep')
  let g:airline_right_sep=exists('g:airline_powerline_fonts')?"":"<"
endif
if !exists('g:airline_enable_fugitive')
  let g:airline_enable_fugitive = 1
endif
if !exists('g:airline_enable_syntastic')
  let g:airline_enable_syntastic = 1
endif
let g:airline_fugitive_prefix = exists('g:airline_powerline_fonts')?'   ':'  '
let g:airline_readonly_symbol = exists('g:airline_powerline_fonts')?'':'RO'
let g:airline_linecolumn_prefix = exists('g:airline_powerline_fonts')?' ':':'
let g:airline_theme = 'default'

set laststatus=2

let s:airline_colors_normal = g:airline#themes#{g:airline_theme}#normal
let s:airline_colors_insert = g:airline#themes#{g:airline_theme}#insert
let s:airline_colors_normal = g:airline#themes#{g:airline_theme}#normal

function! s:highlight(colors)
  let cmd = printf('hi %s %s %s %s %s %s %s',
        \ a:colors[0],
        \ a:colors[1] != '' ? 'guifg='.a:colors[1] : '',
        \ a:colors[2] != '' ? 'guibg='.a:colors[2] : '',
        \ a:colors[3] != '' ? 'ctermfg='.a:colors[3] : '',
        \ a:colors[4] != '' ? 'ctermbg='.a:colors[4] : '',
        \ a:colors[5] != '' ? 'gui='.a:colors[5] : '',
        \ a:colors[5] != '' ? 'term='.a:colors[5] : '')
  exec cmd
endfunction

function! AirlineModePrefix()
  let l:mode = mode()

  call <sid>highlight(s:airline_colors_normal.statusline)
  call <sid>highlight(s:airline_colors_normal.statusline_nc)
  call <sid>highlight(s:airline_colors_normal.inactive)
  call <sid>highlight(s:airline_colors_normal.mode)
  call <sid>highlight(s:airline_colors_normal.mode_seperator)
  call <sid>highlight(s:airline_colors_normal.info)
  call <sid>highlight(s:airline_colors_normal.info_seperator)
  call <sid>highlight(s:airline_colors_normal.file)

  if l:mode ==# "i" || l:mode ==# "R"
    call <sid>highlight(s:airline_colors_insert.statusline)
    call <sid>highlight(s:airline_colors_insert.mode)
    call <sid>highlight(s:airline_colors_insert.mode_seperator)
    call <sid>highlight(s:airline_colors_insert.info)
    call <sid>highlight(s:airline_colors_insert.info_seperator)
  elseif l:mode ==? "v" || l:mode ==# ""
    call <sid>highlight(s:airline_colors_visual.statusline)
    call <sid>highlight(s:airline_colors_visual.mode)
    call <sid>highlight(s:airline_colors_visual.mode_seperator)
    call <sid>highlight(s:airline_colors_visual.info)
    call <sid>highlight(s:airline_colors_visual.info_seperator)
  endif

  if l:mode ==# "n"
    return "  NORMAL "
  elseif l:mode ==# "i"
    return "  INSERT "
  elseif l:mode ==# "R"
    return "  RPLACE "
  elseif l:mode ==# "v"
    return "  VISUAL "
  elseif l:mode ==# "V"
    return "  V·LINE "
  elseif l:mode ==# "c"
    return "  CMD    "
  elseif l:mode ==# ""
    return "  V·BLCK "
  else
    return l:mode
  endif
endfunction

" init colors on startup
call AirlineModePrefix()

function! s:update_statusline(active)
  let l:mode_color = a:active ? "%2*" : "%9*"
  let l:mode_sep_color = a:active ? "%3*" : "%9*"
  let l:info_color = a:active ? "%4*" : "%9*"
  let l:info_sep_color = a:active ? "%5*" : "%9*"
  let l:status_color = a:active ? "%*" : "%9*"
  let l:file_flag_color = a:active ? "%6*" : "%9*"

  let sl = a:active ? l:mode_color."%{AirlineModePrefix()}".l:mode_sep_color : l:mode_color." NORMAL %9*"
  let sl.="%{g:airline_left_sep}".l:info_color
  let sl.="%{g:airline_enable_fugitive&&exists('g:loaded_fugitive')? g:airline_fugitive_prefix.fugitive#head():''}\ "
  let sl.=l:info_sep_color."%{g:airline_left_sep}"
  if a:active
    let sl.=l:status_color."\ %{exists('g:bufferline_loaded')?bufferline#generate_string():'%f'}\ "
  else
    let sl.=" ".bufname(winbufnr(winnr()))
  endif
  let sl.="%#warningmsg#"
  let sl.="%{g:airline_enable_syntastic&&exists('g:loaded_syntastic_plugin')?SyntasticStatuslineFlag():''}"
  let sl.=l:status_color."%<%=".l:file_flag_color."%{&ro? g:airline_readonly_symbol :''}"
  let sl.=l:status_color."\ %{strlen(&filetype)>0?&filetype:''}\ "
  let sl.=l:info_sep_color."%{g:airline_right_sep}".l:info_color."\ "
  let sl.="%{strlen(&fileencoding)>0?&fileencoding:''}"
  let sl.="%{strlen(&fileformat)>0?'['.&fileformat.']':''}"
  let sl.="\ ".l:mode_sep_color."%{g:airline_right_sep}"
  let sl.=l:mode_color."\ %3p%%\ ".g:airline_linecolumn_prefix."%3l:%3c\ "
  call setwinvar(winnr(), '&statusline', sl)
endfunction

augroup airline
  au!
  autocmd WinLeave * call <sid>update_statusline(0)
  autocmd VimEnter,WinEnter,BufWinEnter * call <sid>update_statusline(1)
  autocmd ColorScheme * hi clear StatusLine | hi clear StatusLineNC
augroup END
