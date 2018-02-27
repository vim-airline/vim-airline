" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:has_fugitive = exists('*fugitive#head')
let s:has_lawrencium = exists('*lawrencium#statusline')
let s:has_vcscommand = get(g:, 'airline#extensions#branch#use_vcscommand', 0) && exists('*VCSCommandGetStatusLine')

if !s:has_fugitive && !s:has_lawrencium && !s:has_vcscommand
  finish
endif

" s:vcs_config contains static configuration of VCSes and their status relative
" to the active file.
" 'branch'    - The name of currently active branch. This field is empty iff it
"               has not been initialized yet or the current file is not in
"               an active branch.
" 'untracked' - Cache of untracked files represented as a dictionary with files
"               as keys. A file has a not exists symbol set as its value if it
"               is untracked. A file is present in this dictionary iff its
"               status is considered up to date.
" 'untracked_mark' - used as regexp to test against the output of 'cmd'
let s:vcs_config = {
\  'git': {
\    'exe': 'git',
\    'cmd': 'git status --porcelain -- ',
\    'untracked_mark': '??',
\    'exclude': '\.git',
\    'update_branch': 's:update_git_branch',
\    'display_branch': 's:display_git_branch',
\    'branch': '',
\    'untracked': {},
\  },
\  'mercurial': {
\    'exe': 'hg',
\    'cmd': 'hg status -u -- ',
\    'untracked_mark': '?',
\    'exclude': '\.hg',
\    'update_branch': 's:update_hg_branch',
\    'display_branch': 's:display_hg_branch',
\    'branch': '',
\    'untracked': {},
\  },
\}

" Initializes b:buffer_vcs_config. b:buffer_vcs_config caches the branch and
" untracked status of the file in the buffer. Caching those fields is necessary,
" because s:vcs_config may be updated asynchronously and s:vcs_config fields may
" be invalid during those updates. b:buffer_vcs_config fields are updated
" whenever corresponding fields in s:vcs_config are updated or an inconsistency
" is detected during update_* operation.
"
" b:airline_head caches the head string it is empty iff it needs to be
" recalculated. b:airline_head is recalculated based on b:buffer_vcs_config.
function! s:init_buffer()
  let b:buffer_vcs_config = {}
  for vcs in keys(s:vcs_config)
    let b:buffer_vcs_config[vcs] = {
          \     'branch': '',
          \     'untracked': '',
          \   }
  endfor
  unlet! b:airline_head
endfunction

let s:head_format = get(g:, 'airline#extensions#branch#format', 0)
if s:head_format == 1
  function! s:format_name(name)
    return fnamemodify(a:name, ':t')
  endfunction
elseif s:head_format == 2
  function! s:format_name(name)
    return pathshorten(a:name)
  endfunction
elseif type(s:head_format) == type('')
  function! s:format_name(name)
    return call(s:head_format, [a:name])
  endfunction
else
  function! s:format_name(name)
    return a:name
  endfunction
endif


" Fugitive special revisions. call '0' "staging" ?
let s:names = {'0': 'index', '1': 'orig', '2':'fetch', '3':'merge'}
let s:sha1size = get(g:, 'airline#extensions#branch#sha1_len', 7)

function! s:update_git_branch()
  if !s:has_fugitive
    let s:vcs_config['git'].branch = ''
    return
  endif

  let s:vcs_config['git'].branch = fugitive#head(s:sha1size)
  if s:vcs_config['git'].branch is# 'master' && winwidth(0) < 81
    " Shorten default a bit
    let s:vcs_config['git'].branch='mas'
  endif
endfunction

function! s:display_git_branch()
  let name = b:buffer_vcs_config['git'].branch
  try
    let commit = fugitive#buffer().commit()

    if has_key(s:names, commit)
      let name = get(s:names, commit)."(".name.")"
    elseif !empty(commit)
      let ref = fugitive#repo().git_chomp('describe', '--all', '--exact-match', commit)
      if ref !~ "^fatal: no tag exactly matches"
        let name = s:format_name(substitute(ref, '\v\C^%(heads/|remotes/|tags/)=','',''))."(".name.")"
      else
        let name = commit[0:s:sha1size-1]."(".name.")"
      endif
    endif
  catch
  endtry

  return name
endfunction

function! s:update_hg_branch()
  if s:has_lawrencium
    let cmd='LC_ALL=C hg qtop'
    let stl=lawrencium#statusline()
    let file=expand('%:p')
    if !empty(stl) && get(b:, 'airline_do_mq_check', 1)
      if g:airline#init#vim_async
        call airline#async#get_mq_async(cmd, file)
      elseif has("nvim")
        call airline#async#nvim_get_mq_async(cmd, file)
      else
        " remove \n at the end of the command
        let output=system(cmd)[0:-2]
        call airline#async#mq_output(output, file)
      endif
    endif
    " do not do mq check anymore
    let b:airline_do_mq_check = 0
    if exists("b:mq") && !empty(b:mq)
      if stl is# 'default'
        " Shorten default a bit
        let stl='def'
      endif
      let stl.=' ['.b:mq.']'
    endif
    let s:vcs_config['mercurial'].branch = stl
  else
    let s:vcs_config['mercurial'].branch = ''
  endif
endfunction

function! s:display_hg_branch()
  return b:buffer_vcs_config['mercurial'].branch
endfunction

function! s:update_branch()
  for vcs in keys(s:vcs_config)
    call {s:vcs_config[vcs].update_branch}()
    if b:buffer_vcs_config[vcs].branch != s:vcs_config[vcs].branch
      let b:buffer_vcs_config[vcs].branch = s:vcs_config[vcs].branch
      unlet! b:airline_head
    endif
  endfor
endfunction

function! airline#extensions#branch#update_untracked_config(file, vcs)
  if !has_key(s:vcs_config[a:vcs].untracked, a:file)
    return
  elseif s:vcs_config[a:vcs].untracked[a:file] != b:buffer_vcs_config[a:vcs].untracked
    let b:buffer_vcs_config[a:vcs].untracked = s:vcs_config[a:vcs].untracked[a:file]
    unlet! b:airline_head
  endif
endfunction

function! s:update_untracked()
  let file = expand("%:p")
  if empty(file) || isdirectory(file)
    return
  endif

  let needs_update = 1
  for vcs in keys(s:vcs_config)
    if file =~ s:vcs_config[vcs].exclude
      " Skip check for files that live in the exclude directory
      let needs_update = 0
    endif
    if has_key(s:vcs_config[vcs].untracked, file)
      let needs_update = 0
      call airline#extensions#branch#update_untracked_config(file, vcs)
    endif
  endfor

  if !needs_update
    return
  endif

  for vcs in keys(s:vcs_config)
    let config = s:vcs_config[vcs]
    if g:airline#init#vim_async
      " Note that asynchronous update updates s:vcs_config only, and only
      " s:update_untracked updates b:buffer_vcs_config. If s:vcs_config is
      " invalidated again before s:update_untracked is called, then we lose the
      " result of the previous call, i.e. the head string is not updated. It
      " doesn't happen often in practice, so we let it be.
      call airline#async#vim_vcs_untracked(config, file)
    else
      " nvim async or vim without job-feature
      call airline#async#nvim_vcs_untracked(config, file, vcs)
    endif
  endfor
endfunction

function! airline#extensions#branch#head()
  if !exists('b:buffer_vcs_config')
    call s:init_buffer()
  endif

  call s:update_branch()
  call s:update_untracked()

  if exists('b:airline_head') && !empty(b:airline_head)
    return b:airline_head
  endif

  let b:airline_head = ''
  let vcs_priority = get(g:, "airline#extensions#branch#vcs_priority", ["git", "mercurial"])

  let heads = []
  for vcs in vcs_priority
    if !empty(b:buffer_vcs_config[vcs].branch)
      let heads += [vcs]
    endif
  endfor

  for vcs in heads
    if !empty(b:airline_head)
      let b:airline_head .= ' | '
    endif
    if len(heads) > 1
      let b:airline_head .= s:vcs_config[vcs].exe .':'
    endif
    let b:airline_head .= s:format_name({s:vcs_config[vcs].display_branch}())
    let b:airline_head .= b:buffer_vcs_config[vcs].untracked
  endfor

  if empty(heads)
    if s:has_vcscommand
      call VCSCommandEnableBufferSetup()
      if exists('b:VCSCommandBufferInfo')
        let b:airline_head = s:format_name(get(b:VCSCommandBufferInfo, 0, ''))
      endif
    endif
  endif

  if exists("g:airline#extensions#branch#displayed_head_limit")
    let w:displayed_head_limit = g:airline#extensions#branch#displayed_head_limit
    if len(b:airline_head) > w:displayed_head_limit - 1
      let b:airline_head = b:airline_head[0:(w:displayed_head_limit - 1)].(&encoding ==? 'utf-8' ?  '…' : '.')
    endif
  endif

  let minwidth = empty(get(b:, 'airline_hunks', '')) ? 14 : 7
  let b:airline_head = airline#util#shorten(b:airline_head, 120, minwidth)
  return b:airline_head
endfunction

function! airline#extensions#branch#get_head()
  let head = airline#extensions#branch#head()
  let empty_message = get(g:, 'airline#extensions#branch#empty_message', '')
  let symbol = get(g:, 'airline#extensions#branch#symbol', g:airline_symbols.branch)
  return empty(head)
        \ ? empty_message
        \ : printf('%s%s', empty(symbol) ? '' : symbol.(g:airline_symbols.space), head)
endfunction

function! s:reset_untracked_cache(shellcmdpost)
  " shellcmdpost - whether function was called as a result of ShellCmdPost hook
  if !g:airline#init#vim_async && !has('nvim')
    if a:shellcmdpost
      " Clear cache only if there was no error or the script uses an
      " asynchronous interface. Otherwise, cache clearing would overwrite
      " v:shell_error with a system() call inside get_*_untracked.
      if v:shell_error
        return
      endif
    endif
  endif

  let file = expand("%:p")
  for vcs in keys(s:vcs_config)
    " Dump the value of the cache for the current file. Partially mitigates the
    " issue of cache invalidation happening before a call to
    " s:update_untracked()
    call airline#extensions#branch#update_untracked_config(file, vcs)
    let s:vcs_config[vcs].untracked = {}
  endfor
endfunction

function! airline#extensions#branch#init(ext)
  call airline#parts#define_function('branch', 'airline#extensions#branch#get_head')

  autocmd ShellCmdPost,CmdwinLeave * unlet! b:airline_head b:airline_do_mq_check
  autocmd User AirlineBeforeRefresh unlet! b:airline_head b:airline_do_mq_check
  autocmd BufWritePost * call s:reset_untracked_cache(0)
  autocmd ShellCmdPost * call s:reset_untracked_cache(1)
endfunction
