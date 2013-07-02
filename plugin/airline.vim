if &cp || v:version < 702 || (exists('g:loaded_airline') && g:loaded_airline)
  finish
endif
let g:loaded_airline = 1
if !exists('g:airline_left_sep')
  let g:airline_left_sep = exists('g:airline_powerline_fonts')?"":">"
endif
if !exists('g:airline_right_sep')
  let g:airline_right_sep = exists('g:airline_powerline_fonts')?"":"<"
endif
if !exists('g:airline_enable_fugitive')
  let g:airline_enable_fugitive = 1
endif
if !exists('g:airline_enable_syntastic')
  let g:airline_enable_syntastic = 1
endif
if !exists('g:airline_fugitive_prefix')
  let g:airline_fugitive_prefix = exists('g:airline_powerline_fonts')?'   ':'  '
endif
if !exists('g:airline_readonly_symbol')
  let g:airline_readonly_symbol = exists('g:airline_powerline_fonts')?'':'RO'
endif
if !exists('g:airline_linecolumn_prefix')
  let g:airline_linecolumn_prefix = exists('g:airline_powerline_fonts')?' ':':'
endif
if !exists('g:airline_theme')
  let g:airline_theme = 'default'
endif
if !exists('g:airline_modified_detection')
  let g:airline_modified_detection=1
endif

set laststatus=2

for mode in ['normal','insert','visual']
  let s:airline_colors_{mode} = g:airline#themes#{g:airline_theme}#{mode}
  let s:airline_colors_{mode}_modified = g:airline#themes#{g:airline_theme}#{mode}_modified
endfor

let s:airline_mode_map = {
      \ 'n'  : '  NORMAL ',
      \ 'i'  : '  INSERT ',
      \ 'R'  : '  RPLACE ',
      \ 'v'  : '  VISUAL ',
      \ 'V'  : '  V-LINE ',
      \ 'c'  : '  CMD    ',
      \ '' : '  V-BLCK ',
      \ }
let s:airline_highlight_map = {
      \ 'mode'           : 'User2',
      \ 'mode_separator' : 'User3',
      \ 'info'           : 'User4',
      \ 'info_separator' : 'User5',
      \ 'statusline'     : 'StatusLine',
      \ 'statusline_nc'  : 'StatusLineNC',
      \ 'file'           : 'User6',
      \ 'inactive'       : 'User9',
      \ }

function! s:highlight(mode, keys)
  let l:mode = a:mode
  if g:airline_modified_detection && &modified
    let l:mode .= '_modified'
  endif
  for key in a:keys
    if exists('s:airline_colors_{l:mode}') && exists('s:airline_colors_{l:mode}[key]')
      let colors = s:airline_colors_{l:mode}[key]
      if (has('win32') || has('win64')) && !has('gui_running')
        let colors = map(colors, 'v:val != "" && v:val > 128 ? v:val - 128 : v:val')
      endif
      let cmd = printf('hi %s %s %s %s %s %s %s',
            \ s:airline_highlight_map[key],
            \ colors[0] != '' ? 'guifg='.colors[0] : '',
            \ colors[1] != '' ? 'guibg='.colors[1] : '',
            \ colors[2] != '' ? 'ctermfg='.colors[2] : '',
            \ colors[3] != '' ? 'ctermbg='.colors[3] : '',
            \ colors[4] != '' ? 'gui='.colors[4] : '',
            \ colors[4] != '' ? 'term='.colors[4] : '')
      exec cmd
    endif
  endfor
endfunction

function! s:update_statusline(active)
  if &ft == 'qf' || matchstr(expand('%'), 'NERD') ==# 'NERD' || matchstr(expand('%'), 'Tagbar') ==# 'Tagbar'
    return
  endif

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
    let sl.=l:status_color.(exists('g:bufferline_loaded')?"\ %{bufferline#generate_string()}\ ":"\ %f%m\ ")
  else
    let sl.=" ".bufname(winbufnr(winnr()))
  endif
  let sl.="%#warningmsg#"
  let sl.="%{g:airline_enable_syntastic&&exists('g:loaded_syntastic_plugin')?SyntasticStatuslineFlag():''}"
  let sl.=l:status_color."%<%=".l:file_flag_color."%{&ro? g:airline_readonly_symbol :''}"
  let sl.="%q%{&previewwindow?'[preview]':''}"
  let sl.=l:status_color."\ %{strlen(&filetype)>0?&filetype:''}\ "
  let sl.=l:info_sep_color."%{g:airline_right_sep}".l:info_color."\ "
  let sl.="%{strlen(&fileencoding)>0?&fileencoding:''}"
  let sl.="%{strlen(&fileformat)>0?'['.&fileformat.']':''}"
  let sl.="\ ".l:mode_sep_color."%{g:airline_right_sep}"
  let sl.=l:mode_color."\ %3p%%\ ".g:airline_linecolumn_prefix."%3l:%3c\ "
  call setwinvar(winnr(), '&statusline', sl)
endfunction

function! AirlineModePrefix()
  let l:mode = mode()

  call <sid>highlight('normal', ['statusline','statusline_nc','inactive','mode','mode_separator','info','info_separator','file'])

  if l:mode ==# "i" || l:mode ==# "R"
    call <sid>highlight('insert', ['statusline','mode','mode_separator','info','info_separator'])
  elseif l:mode ==? "v" || l:mode ==# ""
    call <sid>highlight('visual', ['statusline','mode','mode_separator','info','info_separator'])
  endif

  if has_key(s:airline_mode_map, l:mode)
    return s:airline_mode_map[l:mode]
  endif
  return l:mode
endfunction

augroup airline
  au!
  autocmd VimEnter * call AirlineModePrefix()
  autocmd WinLeave * call <sid>update_statusline(0)
  autocmd VimEnter,WinEnter,BufWinEnter * call <sid>update_statusline(1)
  autocmd ColorScheme * hi clear StatusLine | hi clear StatusLineNC

  " if you know why lazyredraw affects statusline rendering i'd love to know!
  if !&lazyredraw
    autocmd InsertLeave * :redrawstatus
  endif
augroup END
