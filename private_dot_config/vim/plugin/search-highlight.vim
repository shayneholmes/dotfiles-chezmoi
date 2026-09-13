" as recommended by :help incsearch
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

highlight Search term=reverse ctermbg=142 guibg=DarkGrey
