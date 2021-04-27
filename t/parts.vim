describe 'parts'
  it 'overwrites existing values'
    call airline#parts#define('foo', { 'test': '123' })
    Expect airline#parts#get('foo').test == '123'
    call airline#parts#define('foo', { 'test': '321' })
    Expect airline#parts#get('foo').test == '321'
  end

  it 'can define a function part'
    call airline#parts#define_function('func', 'bar')
    Expect airline#parts#get('func').function == 'bar'
  end

  it 'can define a text part'
    call airline#parts#define_text('text', 'bar')
    Expect airline#parts#get('text').text == 'bar'
  end

  it 'can define a raw part'
    call airline#parts#define_raw('raw', 'bar')
    Expect airline#parts#get('raw').raw == 'bar'
  end

  it 'can define a minwidth'
    call airline#parts#define_minwidth('mw', 123)
    Expect airline#parts#get('mw').minwidth == 123
  end

  it 'can define a condition'
    call airline#parts#define_condition('part', '1')
    Expect airline#parts#get('part').condition == '1'
  end

  it 'can define a accent'
    call airline#parts#define_accent('part', 'red')
    Expect airline#parts#get('part').accent == 'red'
  end

  it 'value should be blank'
    Expect airline#parts#filetype() == ''
  end

  it 'can overwrite a filetype'
    set ft=aaa
    Expect airline#parts#filetype() == 'aaa'
  end

  it 'can overwrite a filetype'
    "GitHub actions's vim's column is smaller than 90
    set ft=aaaa
    if &columns >= 90
      Expect airline#parts#filetype() == 'aaaa'
    else
      Expect airline#parts#filetype() == 'aaa…'
    endif
  end

end
