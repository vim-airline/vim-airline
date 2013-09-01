call airline#init#bootstrap()
call airline#extensions#load()

function! SectionSpec()
endfunction

describe 'section'
  before
    call airline#parts#define_text('text', 'text')
    call airline#parts#define_raw('raw', 'raw')
    call airline#parts#define_function('func', 'SectionSpec')
  end

  it 'should create sections with no separators'
    let s = airline#section#create(['text', 'raw', 'func'])
    Expect s == '%{airline#util#wrap("text",0)}raw%{airline#util#wrap(SectionSpec(),0)}'
  end

  it 'should create left sections with separators'
    let s = airline#section#create_left(['text', 'text'])
    Expect s == '%{airline#util#wrap("text",0)}%{airline#util#append("text",0)}'
  end

  it 'should create right sections with separators'
    let s = airline#section#create_right(['text', 'text'])
    Expect s == '%{airline#util#prepend("text",0)}%{airline#util#wrap("text",0)}'
  end

  it 'should prefix with highlight group if provided'
    call airline#parts#define('hi', {
          \ 'raw': 'hello',
          \ 'highlight': 'hlgroup',
          \ })
    let s = airline#section#create(['hi'])
    Expect s == '%#hlgroup#hello'
  end

  it 'should parse out a section from the distro'
    let s = airline#section#create(['whitespace'])
    Expect s =~ 'airline#extensions#whitespace#check'
  end

  it 'should use parts as is if they are not found'
    let s = airline#section#create(['asdf', 'func'])
    Expect s == 'asdf%{airline#util#wrap(SectionSpec(),0)}'
  end

  it 'should force add separators for raw and missing keys'
    let s = airline#section#create_left(['asdf', 'raw'])
    Expect s == 'asdf > raw'
    let s = airline#section#create_left(['asdf', 'aaaa', 'raw'])
    Expect s == 'asdf > aaaa > raw'
    let s = airline#section#create_right(['raw', '%f'])
    Expect s == 'raw < %f'
    let s = airline#section#create_right(['%t', 'asdf', '%{getcwd()}'])
    Expect s == '%t < asdf < %{getcwd()}'
  end
end

