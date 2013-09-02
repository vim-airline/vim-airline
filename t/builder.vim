call airline#init#bootstrap()

describe 'active builder'
  before
    let s:builder = airline#builder#new({'active': 1})
  end

  it 'should start with an empty statusline'
    let stl = s:builder.build()
    Expect stl == ''
  end

  it 'should transition colors from one to the next'
    call s:builder.add_section('Normal', 'hello')
    call s:builder.add_section('NonText', 'world')
    let stl = s:builder.build()
    Expect stl =~ '%#Normal#hello%#Normal_to_NonText#>%#NonText#world'
  end

  it 'should split left/right sections'
    call s:builder.split()
    let stl = s:builder.build()
    Expect stl =~ '%='
  end

  it 'after split, sections use the right separator'
    call s:builder.split()
    call s:builder.add_section('Normal', 'hello')
    call s:builder.add_section('NonText', 'world')
    let stl = s:builder.build()
    Expect stl =~ '%#Normal#hello%#Normal_to_NonText#<%#NonText#world'
  end
end

describe 'inactive builder'
  before
    let s:builder = airline#builder#new({'active': 0})
  end

  it 'should transition colors from one to the next'
    call s:builder.add_section('Normal', 'hello')
    call s:builder.add_section('NonText', 'world')
    let stl = s:builder.build()
    Expect stl =~ '%#Normal_inactive#hello%#Normal_to_NonText_inactive#>%#NonText_inactive#world'
  end
end

