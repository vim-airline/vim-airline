let g:airline#extensions#tabline#enabled = 1

source plugin/airline.vim
doautocmd VimEnter

describe 'default'

  it 'should use a tabline'
    e! CHANGELOG.md
    sp CONTRIBUTING.md
    Expect &columns == '22'
"     Expect airline#extensions#tabline#get() == ''
  end

end
