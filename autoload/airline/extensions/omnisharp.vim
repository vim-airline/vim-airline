" MIT License
" Plugin: https://github.com/OmniSharp/omnisharp-vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'OmniSharp_loaded', 0)
  finish
endif

function! airline#extensions#omnisharp#server_status(...) abort
  if !exists(':OmniSharpGotoDefinition') || !get(g:, 'OmniSharp_server_stdio', 0)
    return ''
  endif

  let host = OmniSharp#GetHost(bufnr('%'))
  if type(host.job) != v:t_dict || get(host.job, 'stopped')
    return ''
  endif

  let sln = fnamemodify(host.sln_or_dir, ':t')

  if get(host.job, 'loaded', 0)
    return sln
  endif

  try
    let projectsloaded = OmniSharp#project#CountLoaded()
    let projectstotal = OmniSharp#project#CountTotal()
  catch
    " The CountLoaded and CountTotal functions are very new - catch the error
    " when they don't exist
    let projectsloaded = 0
    let projectstotal = 0
  endtry
  return printf('%s(%d/%d)', sln, projectsloaded, projectstotal)
endfunction

function! airline#extensions#omnisharp#init(ext) abort
  call airline#parts#define_function('omnisharp', 'airline#extensions#omnisharp#server_status')
  augroup airline_omnisharp
    autocmd!
    autocmd User OmniSharpStarted,OmniSharpReady,OmniSharpStopped AirlineRefresh!
  augroup END
endfunction
