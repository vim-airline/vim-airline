" some symbols: ▶ » « ◀
if !exists('g:airline_left_sep')
  let g:airline_left_sep="»"
endif
if !exists('g:airline_right_sep')
  let g:airline_right_sep="«"
endif
if !exists('g:airline_enable_fugitive')
  let g:airline_enable_fugitive = 1
endif
if !exists('g:airline_enable_syntastic')
  let g:airline_enable_syntastic = 1
endif

set laststatus=2

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

let g:airline_colors = {
      \ 'mode':           [ 'User2'        , '#00005f' , '#dfff00' , 17  , 190 , 'bold' ] ,
      \ 'mode_seperator': [ 'User3'        , '#dfff00' , '#444444' , 190 , 238 , 'bold' ] ,
      \ 'info':           [ 'User4'        , '#ffffff' , '#444444' , 255 , 238 , ''     ] ,
      \ 'info_seperator': [ 'User5'        , '#444444' , '#202020' , 238 , 234 , 'bold' ] ,
      \ 'statusline':     [ 'StatusLine'   , '#9cffd3' , '#202020' , 85  , 234 , ''     ] ,
      \ 'statusline_nc':  [ 'StatusLineNC' , '#000000' , '#202020' , 232 , 234 , ''     ] ,
      \ 'file':           [ 'User6'        , '#ff0000' , '#1c1c1c' , 160 , 233 , ''     ] ,
      \ 'inactive':       [ 'User8'        , '#4e4e4e' , '#1c1c1c' , 239 , 234 , ''     ] ,
      \ }

let g:airline_colors_insert = {
      \ 'mode':           [ 'User2'        , '#00005f' , '#00dfff' , 17  , 45  , 'bold' ] ,
      \ 'mode_seperator': [ 'User3'        , '#00dfff' , '#005fff' , 45  , 27  , 'bold' ] ,
      \ 'info':           [ 'User4'        , '#ffffff' , '#005fff' , 255 , 27  , ''     ] ,
      \ 'info_seperator': [ 'User5'        , '#005fff' , '#000087' , 27  , 18  , 'bold' ] ,
      \ 'statusline':     [ 'StatusLine'   , '#ffffff' , '#000080' , 15  , 17  , ''     ] ,
      \ }

let g:airline_colors_visual = {
      \ 'mode':           [ 'User2'        , '#000000' , '#ffaf00' , 232 , 214 , 'bold' ] ,
      \ 'mode_seperator': [ 'User3'        , '#ffaf00' , '#ff5f00' , 214 , 202 , ''     ] ,
      \ 'info':           [ 'User4'        , '#000000' , '#ff5f00' , 232 , 202 , ''     ] ,
      \ 'info_seperator': [ 'User5'        , '#000000' , '#5f0000' , 202 , 52  , ''     ] ,
      \ 'statusline':     [ 'StatusLine'   , '#ffffff' , '#5f0000' , 15  , 52  , ''     ] ,
      \ }

function! AirlineModePrefix()
  let l:mode = mode()

  call <sid>highlight(g:airline_colors.statusline)
  call <sid>highlight(g:airline_colors.statusline_nc)
  call <sid>highlight(g:airline_colors.inactive)
  call <sid>highlight(g:airline_colors.mode)
  call <sid>highlight(g:airline_colors.mode_seperator)
  call <sid>highlight(g:airline_colors.info)
  call <sid>highlight(g:airline_colors.info_seperator)
  call <sid>highlight(g:airline_colors.file)

  if l:mode ==# "i" || l:mode ==# 'R'
    call <sid>highlight(g:airline_colors_insert.statusline)
    call <sid>highlight(g:airline_colors_insert.mode)
    call <sid>highlight(g:airline_colors_insert.mode_seperator)
    call <sid>highlight(g:airline_colors_insert.info)
    call <sid>highlight(g:airline_colors_insert.info_seperator)
  elseif l:mode ==? "v" || l:mode ==# ""
    call <sid>highlight(g:airline_colors_visual.statusline)
    call <sid>highlight(g:airline_colors_visual.mode)
    call <sid>highlight(g:airline_colors_visual.mode_seperator)
    call <sid>highlight(g:airline_colors_visual.info)
    call <sid>highlight(g:airline_colors_visual.info_seperator)
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

" init colors
call AirlineModePrefix()

function! s:update_statusline(active)
  let l:mode_color = a:active ? "%2*" : "%8*"
  let l:mode_sep_color = a:active ? "%3*" : "%8*"
  let l:info_color = a:active ? "%4*" : "%8*"
  let l:info_sep_color = a:active ? "%5*" : "%8*"
  let l:status_color = a:active ? "%*" : "%8*"
  let l:file_flag_color = a:active ? "%6*" : "%8*"

  let sl = a:active ? l:mode_color."%{AirlineModePrefix()}".l:mode_sep_color : l:mode_color." NORMAL %8*"
  let sl.="%{g:airline_left_sep}".l:info_color
  let sl.="\ %{g:airline_enable_fugitive&&exists('g:loaded_fugitive')?fugitive#head():''}\ "
  let sl.=l:info_sep_color."%{g:airline_left_sep}"
  if a:active
    let sl.=l:status_color."\ %{exists('g:bufferline_loaded')?bufferline#generate_string():'%f'}\ "
  else
    let sl.=" ".bufname(winbufnr(winnr()))
  endif
  let sl.="%#warningmsg#"
  let sl.="%{g:airline_enable_syntastic&&exists('g:loaded_syntastic_plugin')?SyntasticStatuslineFlag():''}"
  let sl.=l:status_color."%<%=".l:file_flag_color."%{&ro?'RO':''}"
  let sl.=l:status_color."\ %{strlen(&filetype)>0?&filetype:''}\ "
  let sl.=l:info_sep_color."%{g:airline_right_sep}"
  let sl.=l:info_color."\ "
  let sl.="%{strlen(&fileencoding)>0?&fileencoding:''}"
  let sl.="%{strlen(&fileformat)>0?'['.&fileformat.']':''}"
  let sl.="\ ".l:mode_sep_color."%{g:airline_right_sep}"
  let sl.=l:mode_color."\ %3p%%\ :\ %3l:%3c\ "
  call setwinvar(winnr(), '&statusline', sl)
endfunction

augroup airline
  au!
  autocmd WinLeave * call <sid>update_statusline(0)
  autocmd VimEnter,WinEnter,BufWinEnter * call <sid>update_statusline(1)
  autocmd ColorScheme * hi clear StatusLine | hi clear StatusLineNC
augroup END
