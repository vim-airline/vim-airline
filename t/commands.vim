source plugin/airline.vim
doautocmd VimEnter

describe 'commands'
  it 'should toggle off and on'
    execute 'AirlineToggle'
    Expect exists('#airline') to_be_false
    execute 'AirlineToggle'
    Expect exists('#airline') to_be_true
  end

  it 'should toggle whitespace off'
    call airline#extensions#load()
    execute 'AirlineToggleWhitespace'
    Expect exists('#airline_whitespace') to_be_false
  end

  it 'should toggle whitespace on'
    call airline#extensions#load()
    execute 'AirlineToggleWhitespace'
    Expect exists('#airline_whitespace') to_be_true
  end

  it 'should display theme name "simple"'
    execute 'AirlineTheme simple'
    Expect g:airline_theme == 'simple'
  end

  it 'should display theme name "dark"'
    execute 'AirlineTheme dark'
    Expect g:airline_theme == 'dark'
  end

  it 'should display theme name "dark" because specifying a name that does not exist'
    execute 'AirlineTheme doesnotexist'
    Expect g:airline_theme == 'dark'
  end

  it 'should display theme name molokai'
    colors molokai
    Expect g:airline_theme == 'molokai'
  end

  it 'should have a refresh command'
    Expect exists(':AirlineRefresh') to_be_true
  end

  it 'should have a extensions command'
    Expect exists(':AirlineExtensions') to_be_true
  end

end
