let g:airline#extensions#tabline#enabled = 1

source plugin/airline.vim
doautocmd VimEnter

describe 'default'

  it 'should use a tabline'
    e! CHANGELOG.md
    sp CONTRIBUTING.md
    Expect airline#extensions#tabline#get() == ''
  end

  it 'Trigger on BufDelete autocommands'
    e! CHANGELOG.md
    sp CONTRIBUTING.md
    sp README.md
    2bd
    Expect airline#extensions#tabline#get() == ''
  end
end
