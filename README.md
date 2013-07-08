# vim-airline

lean &amp; mean statusline for vim that's light as air

# rationale

there's already [powerline][b], why yet another statusline?

*  it's 100% vimscript; no python needed.
*  it's small.  i want the core plugin to be *less than 200 lines* as a rule (specifically adhering to the [open/closed principle][h]).
*  it gets you 90% of the way there; in addition to all the standard goodies, it integrates with [vim-bufferline][f], [fugitive][d], [unite][i], [ctrlp][j] and [syntastic][e].
*  it looks good with regular fonts, and provides configuration points so you can use unicode or powerline symbols.
*  it's fast to load, taking roughly 1ms.  by comparison, powerline needs 60ms on the same machine.
*  it's fully customizable; if you know a little `statusline` syntax you can tweak it to your needs.
*  it is trivial to write colorschemes; for a minimal theme you need to edit 9 lines of colors. (please send pull requests if you create new themes!)

what about [old powerline][a]?

*  the old version still works well, but since it's deprecated new features won't get added

# why's it called airline?

i wrote the initial version on an airplane, and since it's light as air it turned out to be a good name.  thanks for flying vim!

# installation

this plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

*  [pathogen][k]
  *  `git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline`
*  [neobundle][l]
  *  `NeoBundle 'bling/vim-airline'`
*  [vundle][m]
  *  `Bundle 'bling/vim-airline'`
*  manual
  *  copy all of the files into your `~/.vim` directory

# configuration

`:help airline`

# faq/troubleshooting

*  the powerline font symbols are not showing up
  *  enable them by adding `let g:airline_powerline_fonts=1` to your `~/.vimrc`
  *  the older deprecated [vim-powerline][a] uses different codes compared to the newer [powerline][b].
  *  you can grab prepatched fonts at [powerline-fonts][c], or you can manually set the relevant `g:` variables
*  there is a pause when leaving insert mode
  *  you need to set `ttimeoutlen` to a low number; 50 is recommended
*  you don't see any colors
  *  all of the themes use a 256 terminal color palette.  it's likely that the value of `t_Co` is misconfigured.  please see this [article][n] on how to configure your terminal.  pull requests for 8 and 16 color terminals are welcome.
*  you get the error `Unknown function: fugitive#head`
  *  you are probably using version 1.2, which is very old...download v2 from the [project page][d].
*  airline doesn't appear until i create a new split
  *  add `set laststatus=2` to your vimrc
*  bufferline is printing to the statusline as well as the command bar
  *  you can disable automatic echoing by adding `let g:bufferline_echo = 0` to your vimrc

# bugs

if you encounter a bug, please reproduce it with this [minivimrc][g] repository i created and file an issue.  please provide your operating system and vim version/patch level (can be found with `:version`).  a reproducible gist would be hugely helpful.

# screenshots

### dark theme with a regular font

![img](https://github.com/bling/vim-airline/wiki/screenshots/dark.png)

### dark theme with powerline symbols

![img](https://github.com/bling/vim-airline/wiki/screenshots/dark-powerline.png)

### simple theme

![img](https://github.com/bling/vim-airline/wiki/screenshots/simple.png)

### light theme

![img](https://github.com/bling/vim-airline/wiki/screenshots/light.png)

### badwolf theme with [bufferline][f] integration

![img](https://github.com/bling/vim-airline/wiki/screenshots/badwolf.png)

# contributions

contributions and pull requests are welcome.  please follow the existing coding style as much as possible.

# license

`:h license`

[a]: https://github.com/Lokaltog/vim-powerline
[b]: https://github.com/Lokaltog/powerline
[c]: https://github.com/Lokaltog/powerline-fonts
[d]: https://github.com/tpope/vim-fugitive
[e]: https://github.com/scrooloose/syntastic
[f]: https://github.com/bling/vim-bufferline
[g]: https://github.com/bling/minivimrc
[h]: http://en.wikipedia.org/wiki/Open/closed_principle
[i]: https://github.com/Shougo/unite.vim
[j]: https://github.com/kien/ctrlp.vim
[k]: https://github.com/tpope/vim-pathogen
[l]: https://github.com/Shougo/neobundle.vim
[m]: https://github.com/gmarik/vundle
[n]: http://vim.wikia.com/wiki/256_colors_in_vim
