" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2 et

scriptencoding utf-8

if !exists(":def") || !airline#util#has_vim9_script()

  " Legacy Vim Script Implementation

  " generates a dictionary which defines the colors for each highlight group
  function! airline#themes#generate_color_map(sect1, sect2, sect3, ...)
    let palette = {
          \ 'airline_a': [ a:sect1[0] , a:sect1[1] , a:sect1[2] , a:sect1[3] , get(a:sect1 , 4 , '') ] ,
          \ 'airline_b': [ a:sect2[0] , a:sect2[1] , a:sect2[2] , a:sect2[3] , get(a:sect2 , 4 , '') ] ,
          \ 'airline_c': [ a:sect3[0] , a:sect3[1] , a:sect3[2] , a:sect3[3] , get(a:sect3 , 4 , '') ] ,
          \ }

    if a:0 > 0
      call extend(palette, {
            \ 'airline_x': [ a:1[0] , a:1[1] , a:1[2] , a:1[3] , get(a:1 , 4 , '' ) ] ,
            \ 'airline_y': [ a:2[0] , a:2[1] , a:2[2] , a:2[3] , get(a:2 , 4 , '' ) ] ,
            \ 'airline_z': [ a:3[0] , a:3[1] , a:3[2] , a:3[3] , get(a:3 , 4 , '' ) ] ,
            \ })
    else
      call extend(palette, {
            \ 'airline_x': [ a:sect3[0] , a:sect3[1] , a:sect3[2] , a:sect3[3] , '' ] ,
            \ 'airline_y': [ a:sect2[0] , a:sect2[1] , a:sect2[2] , a:sect2[3] , '' ] ,
            \ 'airline_z': [ a:sect1[0] , a:sect1[1] , a:sect1[2] , a:sect1[3] , '' ] ,
            \ })
    endif

    return palette
  endfunction

  function! airline#themes#get_highlight(group, ...)
    return call('airline#highlighter#get_highlight', [a:group] + a:000)
  endfunction

  function! airline#themes#get_highlight2(fg, bg, ...)
    return call('airline#highlighter#get_highlight2', [a:fg, a:bg] + a:000)
  endfunction

  function! airline#themes#patch(palette)
    for mode in keys(a:palette)
      if mode == 'accents'
        continue
      endif
      if !has_key(a:palette[mode], 'airline_warning')
        let a:palette[mode]['airline_warning'] = [ '#000000', '#df5f00', 232, 166 ]
      endif
      if !has_key(a:palette[mode], 'airline_error')
        let a:palette[mode]['airline_error'] = [ '#000000', '#990000', 232, 160 ]
      endif
      if !has_key(a:palette[mode], 'airline_term')
        let a:palette[mode]['airline_term'] = [ '#9cffd3', '#202020', 85, 232]
      endif
    endfor

    let a:palette.accents = get(a:palette, 'accents', {})
    let a:palette.accents.none = [ '', '', '', '', '' ]
    let a:palette.accents.bold = [ '', '', '', '', 'bold' ]
    let a:palette.accents.italic = [ '', '', '', '', 'italic' ]

    if !has_key(a:palette.accents, 'red')
      let a:palette.accents.red = [ '#ff0000' , '' , 160 , '' ]
    endif
    if !has_key(a:palette.accents, 'green')
      let a:palette.accents.green = [ '#008700' , '' , 22  , '' ]
    endif
    if !has_key(a:palette.accents, 'blue')
      let a:palette.accents.blue = [ '#005fff' , '' , 27  , '' ]
    endif
    if !has_key(a:palette.accents, 'yellow')
      let a:palette.accents.yellow = [ '#dfff00' , '' , 190 , '' ]
    endif
    if !has_key(a:palette.accents, 'orange')
      let a:palette.accents.orange = [ '#df5f00' , '' , 166 , '' ]
    endif
    if !has_key(a:palette.accents, 'purple')
      let a:palette.accents.purple = [ '#af00df' , '' , 128 , '' ]
    endif
  endfunction
  finish
else
  " New Vim9 Script Implementation
  def airline#themes#generate_color_map(sect1: list<any>, sect2: list<any>, sect3: list<any>, ...rest: list<any>): dict<any>
    # all sections should be string
    for section in [sect1, sect2, sect3] + rest
      map(section, (_, v) => type(v) != type('') ? string(v) : v)
    endfor

    var palette = {
      'airline_a': [ sect1[0], sect1[1], sect1[2], sect1[3], get(sect1, 4, '') ],
      'airline_b': [ sect2[0], sect2[1], sect2[2], sect2[3], get(sect2, 4, '') ],
      'airline_c': [ sect3[0], sect3[1], sect3[2], sect3[3], get(sect3, 4, '') ],
      }

    if rest->len() > 0
      extend(palette, {
        'airline_x': [ rest[0][0], rest[0][1], rest[0][2], rest[0][3], get(rest[0], 4, '' ) ],
        'airline_y': [ rest[1][0], rest[1][1], rest[1][2], rest[1][3], get(rest[1], 4, '' ) ],
        'airline_z': [ rest[2][0], rest[2][1], rest[2][2], rest[2][3], get(rest[2], 4, '' ) ],
        })
    else
      extend(palette, {
        'airline_x': [ sect3[0], sect3[1], sect3[2], sect3[3], '' ],
        'airline_y': [ sect2[0], sect2[1], sect2[2], sect2[3], '' ],
        'airline_z': [ sect1[0], sect1[1], sect1[2], sect1[3], '' ],
      })
    endif

    return palette
  enddef

  def airline#themes#get_highlight(group: string, ...modifiers: list<string>): list<string>
    return call('airline#highlighter#get_highlight', [group, modifiers])
  enddef

  def airline#themes#get_highlight2(fg: list<string>, bg: list<string>, ...modifiers: list<string>): list<string>
    return call('airline#highlighter#get_highlight2', [fg, bg] + modifiers)
  enddef

  def airline#themes#patch(palette: dict<any>): void
    for mode in keys(palette)
      if mode == 'accents'
        continue
      endif
      if !has_key(palette[mode], 'airline_warning')
        extend(palette[mode], {airline_warning: [ '#000000', '#df5f00', '232', '166' ]})
      endif
      if !has_key(palette[mode], 'airline_error')
        extend(palette[mode], {airline_error: [ '#000000', '#990000', '232', '160' ]})
      endif
      if !has_key(palette[mode], 'airline_term')
        extend(palette[mode], {airline_term: [ '#9cffd3', '#202020', '85', '232' ]})
      endif
    endfor

    palette.accents = get(palette, 'accents', {})
    extend(palette.accents, {none: [ '', '', '', '', '' ]})
    extend(palette.accents, {bold:  [ '', '', '', '', 'bold' ]})
    extend(palette.accents, {italic: [ '', '', '', '', 'italic' ]})

    if !has_key(palette.accents, 'red')
      extend(palette.accents, {red: [ '#ff0000', '', '160', '' ]})
    endif
    if !has_key(palette.accents, 'green')
      extend(palette.accents, {green: [ '#008700', '', '22', '' ]})
    endif
    if !has_key(palette.accents, 'blue')
      extend(palette.accents, {blue: [ '#005fff', '', '27', '' ]})
    endif
    if !has_key(palette.accents, 'yellow')
      extend(palette.accents, {yellow: [ '#dfff00', '', '190', '' ]})
    endif
    if !has_key(palette.accents, 'orange')
      extend(palette.accents, {orange: [ '#df5f00', '', '166', '' ]})
    endif
    if !has_key(palette.accents, 'purple')
      extend(palette.accents, {purple: [ '#af00df', '', '128', '' ]})
    endif
  enddef
endif
