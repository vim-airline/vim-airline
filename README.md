# vim-airline

lean &amp; mean statusline for vim that's light as air

# rationale

there's already [powerline][b], why yet another statusline?

*  it's standard vimscript, no python needed
*  it's small.  i want the entire plugin to be less than 200 lines as a rule
*  gets you 90% of the way there: in addition to all the standard goodies, supports [fugitive](https://github.com/tpope/vim-fugitive) and [syntastic](https://github.com/scrooloose/syntastic)
*  integration with [vim-bufferline](https://github.com/bling/vim-bufferline)
*  looks good with regular fonts, with support to use powerline font glyths
*  it's fast to load.  since it's so small, it only takes 0.5ms to load.  by comparison, powerline needs 60ms on the same machine.

# why's it called airline?

i wrote this on an airplane, and since it's light as air it turned out to be a good name.  thanks for flying vim!

# configuration

`:help airline`

# faq

1.  the powerline font symbols are not showing up
  *  the older deprecated [vim-powerline][a] uses different codes compared to the newer [powerline][b].
  *  you can grab prepatched fonts at [powerline-fonts][c], or you can manually set the relevant `g:` variables
2.  leaving insert mode does not update the statusline
  *  this has been reproducible on older versions of vim, please use a newer version of vim

# screenshots

## regular font

![img](regular.png)

## powerline font

![img](powerline.png)

# contributions

contributions and pull requests are welcome.

# license

`:h license`

[a]: https://github.com/Lokaltog/vim-powerline
[b]: https://github.com/Lokaltog/powerline
[c]: https://github.com/Lokaltog/powerline-fonts
