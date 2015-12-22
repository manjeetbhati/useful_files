set background=dark

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set incsearch
set smartcase
set smartindent
set ignorecase
set hlsearch


" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
