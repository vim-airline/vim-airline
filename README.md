# vim-airline

Lean &amp; mean statusline for vim that's light as air.

![img](https://github.com/bling/vim-airline/wiki/screenshots/demo.gif)

# Features

*  tiny core written with extensibility in mind ([open/closed principle][8]).
*  integrates with a variety of plugins, including: [vim-bufferline][6], [fugitive][4], [unite][9], [ctrlp][10], [minibufexpl][15], [gundo][16], [undotree][17], [nerdtree][18], [tagbar][19], [vim-gitgutter][29], [vim-signify][30], [syntastic][5], [lawrencium][21] and [virtualenv][31]
*  looks good with regular fonts and provides configuration points so you can use unicode or powerline symbols.
*  optimized for speed; it loads in under a millisecond.
*  extensive suite of themes for popular colorschemes including [solarized][23] (dark and light), [tomorrow][24] (all variants), [molokai][25], [jellybeans][26] and others; have a look at the [screenshots][14] in the wiki.
*  supports 7.2 as the minimum Vim version

# Straightforward customization

If you don't like the defaults, you can replace all sections with standard `statusline` syntax.

![image](https://f.cloud.github.com/assets/306502/1009429/d69306da-0b38-11e3-94bf-7c6e3eef41e9.png)

# Extensible pipeline

![image](https://f.cloud.github.com/assets/306502/1012157/8d3fc108-0b6a-11e3-95e3-88c892a70e08.png)

# Integration with external plugins

vim-airline provides seamless integration with a variety of plugins.  These extensions will be lazily loaded if and only if you have the other plugins installed (and of course you can turn them off if you don't like it).

### [ctrlp.vim][10]
![image](https://f.cloud.github.com/assets/306502/962258/7345a224-04ec-11e3-8b5a-f11724a47437.png)

### [unite.vim][9]
![image](https://f.cloud.github.com/assets/306502/962319/4d7d3a7e-04ed-11e3-9d59-ab29cb310ff8.png)

### [tagbar][19]
![image](https://f.cloud.github.com/assets/306502/962150/7e7bfae6-04ea-11e3-9e28-32af206aed80.png)

### [csv.vim][28]
![image](https://f.cloud.github.com/assets/306502/962204/cfc1210a-04eb-11e3-8a93-42e6bcd21efa.png)

### [syntastic][5]
![image](https://f.cloud.github.com/assets/306502/962864/9824c484-04f7-11e3-9928-da94f8c7da5a.png)

### whitespace
![image](https://f.cloud.github.com/assets/306502/962401/2a75385e-04ef-11e3-935c-e3b9f0e954cc.png)

### hunks ([vim-gitgutter][29] & [vim-signify][30])
![image](https://f.cloud.github.com/assets/306502/995185/73fc7054-09b9-11e3-9d45-618406c6ed98.png)

### [virtualenv][31]
![image](https://f.cloud.github.com/assets/390964/1022566/cf81f830-0d98-11e3-904f-cf4fe3ce201e.png)

# Rationale

There's already [powerline][2], why yet another statusline?

*  100% vimscript; no python needed.

What about [vim-powerline][1]?

*  the author has been active developing powerline, which was rewritten in python and expands its capabilities to tools outside of Vim, such as bash, zsh, and tmux.
*  vim-powerline has been deprecated as a result, and no features will be added to it.
*  vim-powerline uses different font codes, so if you want to use it with a powerline themed tmux (for example), it will not work.

# Where did the name come from?

I wrote the initial version on an airplane, and since it's light as air it turned out to be a good name.  Thanks for flying vim!

# Installation

This plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

*  [Pathogen][11]
  *  `git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline`
*  [NeoBundle][12]
  *  `NeoBundle 'bling/vim-airline'`
*  [Vundle][13]
  *  `Bundle 'bling/vim-airline'`
*  [VAM][22]
  *  `call vam#ActivateAddons([ 'vim-airline' ])`
*  manual
  *  copy all of the files into your `~/.vim` directory

# Configuration

`:help airline`

# Integrating with powerline fonts

For the nice looking powerline symbols to appear, you will need to install a patched font.  Instructions can be found in the official powerline [documentation][20].  Prepatched fonts can be found in the [powerline-fonts][3] repository.

Finally, enable them in vim-airline by adding `let g:airline_powerline_fonts = 1` to your vimrc.

# FAQ

Solutions to common problems can be found in the [Wiki][27].

# Screenshots

A full list of screenshots for various themes can be found in the [Wiki][14].

# Bugs

Tracking down bugs can take a very long time due to different configurations, versions, and operating systems.  To ensure a timely response, please help me out by doing the following:

*  reproduce it with this [minivimrc][7] repository to rule out any configuration conflicts.
*  a link to your vimrc or a gist which shows how you configured the plugin(s).
*  and so I can reproduce; your `:version` of vim, and the commit of vim-airline you're using.

# Contributions

Contributions and pull requests are welcome.  Please take note of the following guidelines:

*  adhere to the existing style as much as possible; notably, 2 space indents and long-form keywords.
*  keep the history clean! squash your branches before you submit a pull request. `pull --rebase` is your friend.
*  any changes to the core should be tested against Vim 7.2.
*  if you submit a theme, please create a screenshot so it can be added to the [Wiki][14].

# License

MIT license. Copyright (c) 2013 Bailey Ling.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/bling/vim-airline/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

[1]: https://github.com/Lokaltog/vim-powerline
[2]: https://github.com/Lokaltog/powerline
[3]: https://github.com/Lokaltog/powerline-fonts
[4]: https://github.com/tpope/vim-fugitive
[5]: https://github.com/scrooloose/syntastic
[6]: https://github.com/bling/vim-bufferline
[7]: https://github.com/bling/minivimrc
[8]: http://en.wikipedia.org/wiki/Open/closed_principle
[9]: https://github.com/Shougo/unite.vim
[10]: https://github.com/kien/ctrlp.vim
[11]: https://github.com/tpope/vim-pathogen
[12]: https://github.com/Shougo/neobundle.vim
[13]: https://github.com/gmarik/vundle
[14]: https://github.com/bling/vim-airline/wiki/Screenshots
[15]: https://github.com/techlivezheng/vim-plugin-minibufexpl
[16]: https://github.com/sjl/gundo.vim
[17]: https://github.com/mbbill/undotree
[18]: https://github.com/scrooloose/nerdtree
[19]: https://github.com/majutsushi/tagbar
[20]: https://powerline.readthedocs.org/en/latest/fontpatching.html
[21]: https://bitbucket.org/ludovicchabant/vim-lawrencium
[22]: https://github.com/MarcWeber/vim-addon-manager
[23]: https://github.com/altercation/solarized
[24]: https://github.com/chriskempson/tomorrow-theme
[25]: https://github.com/tomasr/molokai
[26]: https://github.com/nanotech/jellybeans.vim
[27]: https://github.com/bling/vim-airline/wiki/FAQ
[28]: https://github.com/chrisbra/csv.vim
[29]: https://github.com/airblade/vim-gitgutter
[30]: https://github.com/mhinz/vim-signify
[31]: https://github.com/jmcantrell/vim-virtualenv
