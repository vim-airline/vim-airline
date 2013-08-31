call airline#init#bootstrap()

function! SectionSpec()
endfunction

describe 'section'
  before
    call airline#parts#define_text('text', 'text')
    call airline#parts#define_raw('raw', 'raw')
    call airline#parts#define_function('func', 'SectionSpec')
    call airline#parts#define('hi', {
          \ 'raw': 'hello',
          \ 'highlight': 'hlgroup',
          \ })
  end

  it 'should create sections with no separators'
    let s = airline#section#create(['text', 'raw', 'func'])
    Expect s == '%{"text"}raw%{SectionSpec()}'
  end

  it 'should create left sections with separators'
    let s = airline#section#create_left(['text', 'text'])
    Expect s == '%{"text"}%{airline#util#append("text")}'
  end

  it 'should create right sections with separators'
    let s = airline#section#create_right(['text', 'text'])
    Expect s == '%{airline#util#prepend("text")}%{"text"}'
  end

  it 'should prefix with highlight group if provided'
    let s = airline#section#create(['hi'])
    Expect s == '%#hlgroup#hello'
  end
end

