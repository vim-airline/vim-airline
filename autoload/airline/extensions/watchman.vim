function! airline#extensions#watchman#get_state()
	let l:cwd = fnamemodify(getcwd(), ':t')
	if !get(w:, 'airline_active', 0) || (l:cwd != 'ember-app' && l:cwd != 'Hosted')
		return ''
	endif

	" Set default status if not defined yet
	" After this initialization, ToggleWatchmanProcess() function will be
	" handling toggling this variable. Of course, this approach would display 
	" incorrect information if process was toggled outside of vim, and I don't
	" plan on doing such dumb thing when I can do everything in vim.
	if !exists('g:watchman_running')
		let l:result=system('getWatchmanProcessState')
		if l:result == 'running'
			let g:watchman_running = 1
		else
			let g:watchman_running = 0
		endif
	endif

	if g:watchman_running == 1
		return 'watchman running'
	else
		return 'watchman paused'
	endif

endfunction

function! airline#extensions#watchman#init(ext)
	call airline#parts#define_function('watchman', 'airline#extensions#watchman#get_state')
endfunction
