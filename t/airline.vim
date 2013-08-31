call airline#init#bootstrap()

function! MyFuncref(...)
  call a:1.add_raw('hello world')
  return 1
endfunction

function! MyIgnoreFuncref(...)
  return -1
endfunction

function! MyAppend1(...)
  call a:1.add_raw('hello')
endfunction

function! MyAppend2(...)
  call a:1.add_raw('world')
endfunction

describe 'airline'
  before
    let g:airline_statusline_funcrefs = []
  end

  it 'should run user funcrefs first'
    call airline#add_statusline_func('MyFuncref')
    let &statusline = ''
    call airline#update_statusline()
    Expect &statusline =~ 'hello world'
  end

  it 'should not change the statusline with -1'
    call airline#add_statusline_funcref(function('MyIgnoreFuncref'))
    let &statusline = 'foo'
    call airline#update_statusline()
    Expect &statusline == 'foo'
  end

  it 'should support multiple chained funcrefs'
    call airline#add_statusline_func('MyAppend1')
    call airline#add_statusline_func('MyAppend2')
    call airline#update_statusline()
    Expect &statusline =~ 'helloworld'
  end

  it 'should allow users to redefine sections'
    let g:airline_section_a = airline#section#create(['mode', 'mode'])
    call airline#update_statusline()
    Expect &statusline =~ '%{airline#util#wrap(airline#parts#mode(),0)}%{airline#util#wrap(airline#parts#mode(),0)}'
  end
end

