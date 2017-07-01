" MIT License. Copyright (c) 2013-2016 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:has_fugitive = exists('*fugitive#head')
let s:has_lawrencium = exists('*lawrencium#statusline')
let s:has_vcscommand = get(g:, 'airline#extensions#branch#use_vcscommand', 0) && exists('*VCSCommandGetStatusLine')

if !s:has_fugitive && !s:has_lawrencium && !s:has_vcscommand
  finish
endif

let s:has_async = airline#util#async

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
\    'update_branch': 's:update_git_branch',
\    'exclude': '\.git',
\    'branch': '',
\    'untracked': {},
\  },
\  'mercurial': {
\    'exe': 'hg',
\    'cmd': 'hg status -u -- ',
\    'untracked_mark': '?',
\    'exclude': '\.hg',
\    'update_branch': 's:update_hg_branch',
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

let s:git_dirs = {}

function! s:update_git_branch(path)
  if !s:has_fugitive
    let s:vcs_config['git'].branch = ''
    return
  endif

  let name = fugitive#head(7)
  if empty(name)
    if has_key(s:git_dirs, a:path)
      let s:vcs_config['git'].branch = s:git_dirs[a:path]
      return
    endif

    let dir = fugitive#extract_git_dir(a:path)
    if empty(dir)
      let name = ''
    else
      try
        let line = join(readfile(dir . '/HEAD'))
        if strpart(line, 0, 16) == 'ref: refs/heads/'
          let name = strpart(line, 16)
        else
          " raw commit hash
          let name = strpart(line, 0, 7)
        endif
      catch
        let name = ''
      endtry
    endif
  endif

  let s:git_dirs[a:path] = name
  let s:vcs_config['git'].branch = name
endfunction

function! s:update_hg_branch(path)
  if s:has_lawrencium
    let stl=lawrencium#statusline()
    if !empty(stl) && s:has_async
      call s:get_mq_async('LC_ALL=C hg qtop', expand('%:p'))
    endif
    if exists("s:mq") && !empty(s:mq)
      if stl is# 'default'
        " Shorten default a bit
        let stl='def'
      endif
      let stl.=' ['.s:mq.']'
    endif
    let s:vcs_config['mercurial'].branch = stl
  else
    let s:vcs_config['mercurial'].branch = ''
  endif
endfunction

function! s:update_branch()
  let l:path = exists("*fnamemodify") ? fnamemodify(resolve(@%), ":p:h") : expand("%:p:h")
  for vcs in keys(s:vcs_config)
    call {s:vcs_config[vcs].update_branch}(l:path)
    if b:buffer_vcs_config[vcs].branch != s:vcs_config[vcs].branch
      let b:buffer_vcs_config[vcs].branch = s:vcs_config[vcs].branch
      unlet! b:airline_head
    endif
  endfor
endfunction

function! s:update_untracked_in_buffer_config(file, vcs)
  if !has_key(s:vcs_config[a:vcs].untracked, a:file)
    return
  elseif s:vcs_config[a:vcs].untracked[a:file] != b:buffer_vcs_config[a:vcs].untracked
    let b:buffer_vcs_config[a:vcs].untracked = s:vcs_config[a:vcs].untracked[a:file]
    unlet! b:airline_head
  endif
endfunction

function! s:update_untracked()
  let l:file = expand("%:p")
  if empty(l:file) || isdirectory(l:file)
    return
  endif

  let l:needs_update = 1
  for vcs in keys(s:vcs_config)
    if l:file =~ s:vcs_config[vcs].exclude
      " Skip check for files that live in the exclude directory
      let l:needs_update = 0
    endif
    if has_key(s:vcs_config[vcs].untracked, l:file)
      let l:needs_update = 0
      call s:update_untracked_in_buffer_config(l:file, vcs)
    endif
  endfor

  if !l:needs_update
    return
  endif

  for vcs in keys(s:vcs_config)
    let l:config = s:vcs_config[vcs]
    if s:has_async
      " Note that asynchronous update updates s:vcs_config only, and only
      " s:update_untracked updates b:buffer_vcs_config. If s:vcs_config is
      " invalidated again before s:update_untracked is called, then we lose the
      " result of the previous call, i.e. the head string is not updated. It
      " doesn't happen often in practice, so we let it be.
      call s:get_vcs_untracked_async(l:config, l:file)
    else
      let output = airline#util#system(l:config.cmd . shellescape(l:file))
      if output =~? ('^' . l:config.untracked_mark)
        let l:config.untracked[l:file] = get(g:, 'airline#extensions#branch#notexists', g:airline_symbols.notexists)
      else
        let l:config.untracked[l:file] = ''
      endif
      call s:update_untracked_in_buffer_config(l:file, vcs)
    endif
  endfor
endfunction

if s:has_async
  let s:jobs = {}

  function! s:on_stdout(channel, msg) dict abort
    let self.buf .= a:msg
  endfunction

  function! s:on_exit(channel) dict abort
    if self.buf =~? ('^' . self.config['untracked_mark'])
      let self.config.untracked[self.file] = get(g:, 'airline#extensions#branch#notexists', g:airline_symbols.notexists)
    else
      let self.config.untracked[self.file] = ''
    endif
    " b:buffer_vcs_config will be updated on next call of update_untracked if
    " needed
    if has_key(s:jobs, self.file)
      call remove(s:jobs, self.file)
    endif
  endfunction

  function! s:get_vcs_untracked_async(config, file)
    if g:airline#util#is_windows && &shell =~ 'cmd'
      let cmd = a:config['cmd'] . shellescape(a:file)
    else
      let cmd = ['sh', '-c', a:config['cmd'] . shellescape(a:file)]
    endif

    let options = {'config': a:config, 'buf': '', 'file': a:file}
    if has_key(s:jobs, a:file)
      if job_status(get(s:jobs, a:file)) == 'run'
        return
      elseif has_key(s:jobs, a:file)
        call remove(s:jobs, a:file)
      endif
    endif
    let id = job_start(cmd, {
          \ 'err_io':   'out',
          \ 'out_cb':   function('s:on_stdout', options),
          \ 'close_cb': function('s:on_exit', options)})
    let s:jobs[a:file] = id
  endfu

  function! s:on_exit_mq(channel) dict abort
    if !empty(self.buf)
      if self.buf is# 'no patches applied' ||
        \ self.buf =~# "unknown command 'qtop'"
        let self.buf = ''
      elseif exists("s:mq") && s:mq isnot# self.buf
        " make sure, statusline is updated
        unlet! b:airline_head
      endif
      let s:mq = self.buf
    endif
    if has_key(s:jobs, self.file)
      call remove(s:jobs, self.file)
    endif
  endfunction

  function! s:get_mq_async(cmd, file)
    if g:airline#util#is_windows && &shell =~ 'cmd'
      let cmd = a:cmd
    else
      let cmd = ['sh', '-c', a:cmd]
    endif

    let options = {'cmd': a:cmd, 'buf': '', 'file': a:file}
    if has_key(s:jobs, a:file)
      if job_status(get(s:jobs, a:file)) == 'run'
        return
      elseif has_key(s:jobs, a:file)
        call remove(s:jobs, a:file)
      endif
    endif
    let id = job_start(cmd, {
          \ 'err_io':   'out',
          \ 'out_cb':   function('s:on_stdout', options),
          \ 'close_cb': function('s:on_exit_mq', options)})
    let s:jobs[a:file] = id
  endfu
endif

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
  let l:vcs_priority = get(g:, "airline#extensions#branch#vcs_priority", ["git", "mercurial"])

  let l:heads = {}
  for vcs in l:vcs_priority
    if !empty(b:buffer_vcs_config[vcs].branch)
      let l:heads[vcs] = b:buffer_vcs_config[vcs].branch
    endif
  endfor

  for vcs in keys(l:heads)
    if !empty(b:airline_head)
      let b:airline_head .= ' | '
    endif
    let b:airline_head .= (len(l:heads) > 1 ? s:vcs_config[l:vcs].exe .':' : '') . s:format_name(l:heads[l:vcs])
    let b:airline_head .= b:buffer_vcs_config[vcs].untracked
  endfor

  if empty(l:heads)
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

  if has_key(l:heads, 'git') && !s:check_in_path()
    let b:airline_head = ''
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

function! s:check_in_path()
  if !exists('b:airline_file_in_root')
    let root = get(b:, 'git_dir', get(b:, 'mercurial_dir', ''))
    let bufferpath = resolve(fnamemodify(expand('%'), ':p'))

    if !filereadable(root) "not a file
      " if .git is a directory, it's the old submodule format
      if match(root, '\.git$') >= 0
        let root = expand(fnamemodify(root, ':h'))
      else
        " else it's the newer format, and we need to guesstimate
        " 1) check for worktrees
        if match(root, 'worktrees') > -1
          " worktree can be anywhere, so simply assume true here
          return 1
        endif
        " 2) check for submodules
        let pattern = '\.git[\\/]\(modules\)[\\/]'
        if match(root, pattern) >= 0
          let root = substitute(root, pattern, '', '')
        endif
      endif
    endif

    let b:airline_file_in_root = stridx(bufferpath, root) > -1
  endif
  return b:airline_file_in_root
endfunction

function! s:reset_untracked_cache(shellcmdpost)
  " shellcmdpost - whether function was called as a result of ShellCmdPost hook
  if !s:has_async && !has('nvim')
    if a:shellcmdpost
      " Clear cache only if there was no error or the script uses an
      " asynchronous interface. Otherwise, cache clearing would overwrite
      " v:shell_error with a system() call inside get_*_untracked.
      if v:shell_error
        return
      endif
    endif
  endif

  let l:file = expand("%:p")
  for vcs in keys(s:vcs_config)
    " Dump the value of the cache for the current file. Partially mitigates the
    " issue of cache invalidation happening before a call to
    " s:update_untracked()
    call s:update_untracked_in_buffer_config(l:file, l:vcs)
    let s:vcs_config[vcs].untracked = {}
  endfor
endfunction

function! airline#extensions#branch#init(ext)
  call airline#parts#define_function('branch', 'airline#extensions#branch#get_head')

  autocmd BufReadPost * unlet! b:airline_file_in_root
  autocmd ShellCmdPost,CmdwinLeave * unlet! b:airline_head
  autocmd User AirlineBeforeRefresh unlet! b:airline_head
  autocmd BufWritePost * call s:reset_untracked_cache(0)
  autocmd ShellCmdPost * call s:reset_untracked_cache(1)
endfunction
