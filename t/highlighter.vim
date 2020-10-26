let g:airline_theme = 'dark'

describe 'highlighter'
  it 'should create separator highlight groups'
    hi Foo1 ctermfg=1 ctermbg=2
    hi Foo2 ctermfg=3 ctermbg=4
    call airline#highlighter#add_separator('Foo1', 'Foo2', 0)
    let hl = airline#highlighter#get_highlight('Foo1_to_Foo2')
    Expect hl == [ 'NONE', 'NONE', '4', '2', '' ]
  end

  if exists("+termguicolors")
    it 'should create separator highlight groups with termguicolors'
      set termguicolors
      hi Foo1 guifg=#cd0000 guibg=#00cd00 ctermfg=1 ctermbg=2
      hi Foo2 guifg=#cdcd00 guibg=#0000ee ctermfg=3 ctermbg=4
      call airline#highlighter#add_separator('Foo1', 'Foo2', 0)
      let hl = airline#highlighter#get_highlight('Foo1_to_Foo2')
      Expect hl == [ '#0000ee', '#00cd00', '4', '2', '' ]
    end
  endif

  it 'should populate accent colors'
    Expect exists('g:airline#themes#dark#palette.normal.airline_c_red') to_be_false
    Expect hlID('airline_c_red') == 0
    call airline#themes#patch(g:airline#themes#dark#palette)
    call airline#highlighter#add_accent('red')
    call airline#highlighter#highlight(['normal'])
    Expect hlID('airline_c_red') != 0
  end
end
