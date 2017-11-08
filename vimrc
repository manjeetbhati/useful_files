 " !!!!!!!!!!! START-VUNDLE !!!!!!!!!!!!!!!!
  " Vundle stuff https://github.com/VundleVim/Vundle.vim#about
  set nocompatible              " be iMproved, required
  filetype off                  " required
  
  " set the runtime path to include Vundle and initialize
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  " " alternatively, pass a path where Vundle should install plugins
  " "call vundle#begin('~/some/path/here')
  "
  " let Vundle manage Vundle, required
  Plugin 'VundleVim/Vundle.vim'
  "
  " The following are examples of different formats supported.
  " Keep Plugin commands between vundle#begin/end.
  " plugin on GitHub repo
  " Plugin 'tpope/vim-fugitive'
  " " plugin from http://vim-scripts.org/vim/scripts.html
  " Plugin 'L9'
  " " Git plugin not hosted on GitHub
  " Plugin 'git://git.wincent.com/command-t.git'
  " " git repos on your local machine (i.e. when working on your own plugin)
  " Plugin 'file:///home/gmarik/path/to/plugin'
  " " The sparkup vim script is in a subdirectory of this repo called vim.
  " " Pass the path to set the runtimepath properly.
  " Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
  " " Avoid a name conflict with L9
  " Plugin 'user/L9', {'name': 'newL9'}
  
  Plugin 'tpope/vim-fugitive'
  Plugin 'Valloric/YouCompleteMe'
  Plugin 'hynek/vim-python-pep8-indent'
  
  " Shows how many times a search pattern occurs in the current buffer.
  Plugin 'google/vim-searchindex'
  
  " Fuzzy find.
  Plugin 'junegunn/fzf.vim'
  
  " Plugin to use 'ag' to search
  Plugin 'mileszs/ack.vim'
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif
  
  " Shows what has changed in a git file
  Plugin 'airblade/vim-gitgutter'
  
  " Status line
  Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
  
  
  " All of your Plugins must be added before the following line
  call vundle#end()            " required
  filetype plugin indent on    " required
  " To ignore plugin indent changes, instead use:
  "filetype plugin on
  "
  " Brief help
  " :PluginList       - lists configured plugins
  " :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
  " :PluginSearch foo - searches for foo; append `!` to refresh local cache
  " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
  "
  " see :h vundle for more details or wiki for FAQ
  " Put your non-Plugin stuff after this line
  " !!!!!!!!!!! END-VUNDLE !!!!!!!!!!!!!!!!

syntax on
  
set background=dark
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set incsearch
set smartcase
set ignorecase
set hlsearch


" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

