" MIT License. Copyright (c) 2021       DEMAREST Maxime (maxime@indelog.fr)
" Plugin: https://github.com/yegappan/taglist/
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':TlistShowTag')
  finish
endif

function! airline#extensions#taglist#currenttag()
  " Update tag list if taglist is not loaded (else we get an empty tag name)
  " Load yegappan/taglist and vim-scripts/taglist.vim only once.
  let tlist_updated = 0
  if !exists('*taglist#Tlist_Get_Tagname_By_Line()') && !exists('*Tlist_Get_Tagname_By_Line()')
      TlistUpdate
      let tlist_updated = 1
  endif
  if  !tlist_updated && exists('*Tlist_Get_Filenames()')
      let tlist_filenames = Tlist_Get_Filenames()
      if stridx(type(tlist_filenames) == type([]) ? join(tlist_filenames, '\n') : tlist_filenames, expand('%:p')) < 0
          TlistUpdate
      endif
  endif
  " Is this function is not present it'means you use the old vertsion of
  " tag list : https://github.com/vim-scripts/taglist.vim.
  " Please use the new version : https://github.com/yegappan/taglist.
  if exists('*taglist#Tlist_Get_Tagname_By_Line()')
      return taglist#Tlist_Get_Tagname_By_Line()
  else
      return ''
  endif
endfunction

function! airline#extensions#taglist#init(ext)
  call airline#parts#define_function('taglist', 'airline#extensions#taglist#currenttag')
endfunction
