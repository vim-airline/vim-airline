call airline#init#bootstrap()

function! Util1()
  let g:count += 1
endfunction
function! Util2()
  let g:count += 2
endfunction
function! Util3(...)
  let g:count = a:0
endfunction

describe 'util'
  before
    let g:count = 0
  end

  it 'has append wrapper function'
    Expect airline#util#append('') == ''
    Expect airline#util#append('1') == '  > 1'
  end

  it 'has prepend wrapper function'
    Expect airline#util#prepend('') == ''
    Expect airline#util#prepend('1') == '1 < '
  end

  it 'has getwinvar function'
    Expect airline#util#getwinvar(1, 'asdf', '123') == '123'
    call setwinvar(1, 'vspec', 'is cool')
    Expect airline#util#getwinvar(1, 'vspec', '') == 'is cool'
  end

  it 'has exec funcrefs helper functions'
    call airline#util#exec_funcrefs([function('Util1'), function('Util2')])
    Expect g:count == 3

    call airline#util#exec_funcrefs([function('Util3')], 1, 2, 3, 4)
    Expect g:count == 4
  end
end

