# Vim-Airline

Lean &amp; mean statusline for vim that's light as air

# Rationale

There's already [powerline][b], why yet another statusline?

*  It's 100% vimscript; no python needed.
*  It's small.  I want the core plugin to be *less than 200 lines* as a rule (specifically adhering to the [open/closed principle][h]).
*  It gets you 90% of the way there; in addition to all the standard goodies, it integrates with [vim-bufferline][f], [fugitive][d], [unite][i], [ctrlp][j] and [syntastic][e].
*  It looks good with regular fonts, and provides configuration points so you can use unicode or powerline symbols.
*  It's fast to load, taking roughly 1ms.  by comparison, powerline needs 60ms on the same machine.
*  It's fully customizable; if you know a little `statusline` syntax you can tweak it to your needs.
*  It is trivial to write colorschemes; for a minimal theme you need to edit 9 lines of colors. (please send pull requests if you create new themes!)

What about [old powerline][a]?

*  The old version still works well, but since it's deprecated new features won't get added

# Why is it called airline?

I wrote the initial version on an airplane, and since it's light as air it turned out to be a good name.  Thanks for flying vim!

# Installation

This plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

*  [pathogen][k]
  *  `git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline`
*  [neobundle][l]
  *  `NeoBundle 'bling/vim-airline'`
*  [vundle][m]
  *  `Bundle 'bling/vim-airline'`
*  Manual
  *  Copy all of the files into your `~/.vim` directory

# Configuration

`:help airline`

# FAQ/Troubleshooting

*  The powerline font symbols are not showing up
  *  The older deprecated [vim-powerline][a] uses different codes compared to the newer [powerline][b].
  *  You can grab prepatched fonts at [powerline-fonts][c], or you can manually set the relevant `g:` variables
*  There is a pause when leaving insert mode
  *  You need to set `ttimeoutlen` to a low number; 50 is recommended
*  You don't see any colors
  *  All of the themes use a 256 terminal color palette.  It's likely that the value of `t_Co` is misconfigured.  Please see this [article][n] on how to configure your terminal.  Pull requests for 8 and 16 color terminals are welcome.
*  You get the error `Unknown function: fugitive#head`
  *  You are probably using version 1.2, which is very old... Download v2 from the [project page][d].
*  Airline doesn't appear until I create a new split
  *  Add `set laststatus=2` to your vimrc
*  Bufferline is printing to the statusline as well as the command bar
  *  You can disable automatic echoing by adding `let g:bufferline_echo = 0` to your vimrc

# Bugs

If you encounter a bug, please reproduce it with this [minivimrc][g] repository I created and file an issue.  Please provide your operating system and vim version/patch level (can be found with `:version`).  A reproducible gist would be hugely helpful.

# Screenshots

### Dark theme with a regular font

![img](https://github.com/bling/vim-airline/wiki/screenshots/dark.png)

### Dark theme with powerline symbols

![img](https://github.com/bling/vim-airline/wiki/screenshots/dark-powerline.png)

### Simple theme

![img](https://github.com/bling/vim-airline/wiki/screenshots/simple.png)

### Light theme

![img](https://github.com/bling/vim-airline/wiki/screenshots/light.png)

### Badwolf theme with [bufferline][f] integration

![img](https://github.com/bling/vim-airline/wiki/screenshots/badwolf.png)

# Contributions

Contributions and pull requests are welcome.  Please follow the existing coding style as much as possible.

# License

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
