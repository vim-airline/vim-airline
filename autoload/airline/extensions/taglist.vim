" MIT License. Copyright (c) 2021       DEMAREST Maxime (maxime@indelog.fr)
" Plugin: https://github.com/yegappan/taglist/
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':TlistShowTag')
  finish
endif

function! airline#extensions#taglist#currenttag()
  " Update tag list if taglist is not loaded (else we get an empty tag name)
  let tlist_updated = v:false
  if !exists('*Tlist_Get_Filenames()')
      TlistUpdate
      let tlist_updated = v:true
  endif
  if !tlist_updated
      if stridx(Tlist_Get_Filenames(), expand('%:p')) < 0
          TlistUpdate
          let tlist_updated = v:true
      endif
  endif
  return taglist#Tlist_Get_Tagname_By_Line()
endfunction

function! airline#extensions#taglist#init(ext)
  call airline#parts#define_function('taglist', 'airline#extensions#taglist#currenttag')
endfunction
