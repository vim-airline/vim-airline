" 26-Apr-2015
" Copied in from stackoverflow
" http://stackoverflow.com/questions/114431/fast-word-count-function-in-vim
" Renamed 

let s:spc = g:airline_symbols.space

function! airline#extensions#wordcount#word_count()
if mode() == "s"
    return 0
else
    let s:old_status = v:statusmsg
    let position = getpos(".")
    let s:word_count = 0
    exe ":silent normal g\<c-g>"
    let stat = v:statusmsg
    let s:word_count = 0
    if stat != '--No lines in buffer--'
        let s:word_count = str2nr(split(v:statusmsg)[11])
        let v:statusmsg = s:old_status
    end
    call setpos('.', position)
    return s:word_count 
end
endfunction

function! airline#extensions#wordcount#apply(...)
" Call the WordCount function for Markdown files
if &ft == "markdown"
    let w:airline_section_x = "%{airline#extensions#wordcount#word_count()} Words"
endif
endfunction

function! airline#extensions#wordcount#init(ext)
call a:ext.add_statusline_func('airline#extensions#wordcount#apply')
endfunction
