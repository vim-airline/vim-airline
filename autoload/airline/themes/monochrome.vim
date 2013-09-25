let g:airline#themes#monochrome#palette = {}

function! s:load()
  let s:SL = airline#themes#get_highlight('StatusLine')
  let g:airline#themes#monochrome#palette.normal = airline#themes#generate_color_map(s:SL, s:SL, s:SL)
  let g:airline#themes#monochrome#palette.insert = g:airline#themes#monochrome#palette.normal
  let g:airline#themes#monochrome#palette.replace = g:airline#themes#monochrome#palette.normal
  let g:airline#themes#monochrome#palette.visual = g:airline#themes#monochrome#palette.normal

  let s:SLNC = airline#themes#get_highlight('StatusLineNC')
  let g:airline#themes#monochrome#palette.inactive = airline#themes#generate_color_map(s:SLNC, s:SLNC, s:SLNC)
endfunction

call s:load()
augroup airline_monochrome
  autocmd!
  autocmd ColorScheme * call <sid>load()
augroup END
