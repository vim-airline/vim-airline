let g:airline_theme = 'dark'

describe 'highlighter'
  it 'should create separator highlight groups'
    hi Foo1 ctermfg=1 ctermbg=2
    hi Foo2 ctermfg=3 ctermbg=4
    call airline#highlighter#add_separator('Foo1', 'Foo2', 0)
    let hl = airline#highlighter#get_highlight('Foo1_to_Foo2')
    Expect hl == [ '', '', '4', '2', '' ]
  end

  it 'should populate accent colors'
    Expect exists('g:airline#themes#dark#palette.normal.airline_c_red') to_be_false
    Expect exists('g:airline#themes#dark#palette.insert.airline_c_red') to_be_false
    call airline#highlighter#add_accent('airline_c', 'red')
    Expect exists('g:airline#themes#dark#palette.normal.airline_c_red') to_be_true
    Expect exists('g:airline#themes#dark#palette.insert.airline_c_red') to_be_true
  end
end

