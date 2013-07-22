# vim-airline

Lean &amp; mean statusline for vim that's light as air.

![img](https://github.com/bling/vim-airline/wiki/screenshots/light.png)

# Rationale

There's already [powerline][b], why yet another statusline?

*  it's 100% vimscript; no python needed.
*  it's small.  i want the core plugin to be *less than 200 lines* as a rule (specifically adhering to the [open/closed principle][h]).
*  despite the small size, it is fully featured and already integrates with: [vim-bufferline][f], [fugitive][d], [unite][i], [ctrlp][j], [minibufexpl][o], [gundo][p], [undotree][q], [nerdtree][r], [tagbar][s], [syntastic][e] and [lawrencium][u].
*  it looks good with regular fonts, and provides configuration points so you can use unicode or powerline symbols.
*  it's fast to load, taking roughly 1ms.  by comparison, powerline needs 60ms on the same machine.
*  it's fully customizable; if you know a little `statusline` syntax you can tweak it to your needs.
*  it's trivial to write colorschemes; for a minimal theme you need to edit 9 lines of colors. (please send pull requests if you create new themes!)

What about [old powerline][a]?

*  the old version still works well, but since it's deprecated new features won't get added
*  it uses different font codes, which makes it incompatible with other powerline bindings in the same terminal (e.g. bash, zsh, tmux, etc.)

# Where did the name come from?

I wrote the initial version on an airplane, and since it's light as air it turned out to be a good name.  Thanks for flying vim!

# Installation

This plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

*  [pathogen][k]
  *  `git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline`
*  [neobundle][l]
  *  `NeoBundle 'bling/vim-airline'`
*  [vundle][m]
  *  `Bundle 'bling/vim-airline'`
*  manual
  *  copy all of the files into your `~/.vim` directory

# Configuration

`:help airline`

# Integrating with powerline fonts

For the nice looking powerline symbols to appear, you will need to install a patched font.  Instructions can be found in the official powerline [documentation][t].  Prepatched fonts can be found in the [powerline-fonts][c] repository.

Finally, enable them in vim-airline by adding `let g:airline_powerline_fonts = 1` to your vimrc.

# Bugs

If you encounter a bug, please do the following:

*  reproduce it with this [minivimrc][g] repository to rule out any configuration conflicts.
*  specify your version and patch level, as well as operating system (found with `:version`).
*  a link to a gist or your vimrc where it can be reproduced.

# FAQ

Solutions to common problems can be found in the [Wiki](https://github.com/bling/vim-airline/wiki/FAQ).

# Screenshots

A full list of screenshots can be found in the [Wiki][n].

# Contributions

Contributions and pull requests are welcome.  Please take note of the following guidelines:

*  adhere to the existing style as much as possible; notably, 2 space indents and long-form keywords.
*  keep the history clean! squash your branches before you submit a pull request. `pull --rebase` is your friend.
*  this plugin got a lot more popular than i initially expected, if you make changes to the core, please test on as many versions of vim as possible.
*  if you submit a theme, please create a screenshot so it can be added to the [Wiki][n].

# License

Distributed under the same terms as the Vim license.  See `:help license`.


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
[n]: https://github.com/bling/vim-airline/wiki/Screenshots
[o]: https://github.com/techlivezheng/vim-plugin-minibufexpl
[p]: https://github.com/sjl/gundo.vim
[q]: https://github.com/mbbill/undotree
[r]: https://github.com/scrooloose/nerdtree
[s]: https://github.com/majutsushi/tagbar
[t]: https://powerline.readthedocs.org/en/latest/fontpatching.html
[u]: https://bitbucket.org/ludovicchabant/vim-lawrencium
