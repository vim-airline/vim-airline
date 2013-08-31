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
end

