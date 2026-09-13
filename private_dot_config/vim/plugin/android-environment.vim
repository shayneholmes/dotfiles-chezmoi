" phone-specific configuration

let s:runningOnPhone=!empty($ANDROID_DATA)
if !s:runningOnPhone
  finish
endif

" Fn-capslock on the keyboard is labeled "numlock", but yields F1.
" Nerf it.
noremap <F1> <Nop>
noremap! <F1> <Nop>

" Phone keyboard has Z in the up-arrow position, and while I remapped the
" lowercase one, and I haven't remapped the uppercase one. Working around that
" here.
map <S-Up> Z
map! <S-Up> Z
" Map ZZ explicitly, required for reasons unknown
map <S-Up><S-Up> ZZ

" Phone keyboard sometimes types 'nch' out of order
inoremap nc<Space>h nch<Space>
" ...or does weird things
inoremap nh*c nch
inoremap Zz Z
" Also punctuation
noremap  ?[ ?
noremap! ?[ ?
noremap  /[ /
noremap! /[ /
" And numbers
noremap  1' 1
noremap  2, 2
noremap  3. .
noremap  4p 4
noremap  5y 5
noremap  6f 6
noremap  7g 7
noremap  8c 8
noremap  9r 9
noremap  0l 0
noremap! 1' 1
noremap! 2, 2
noremap! 3. .
noremap! 4p 4
noremap! 5y 5
noremap! 6f 6
noremap! 7g 7
noremap! 8c 8
noremap! 9r 9
noremap! 0l 0
noremap !' !
noremap @, @
noremap #. #
noremap .# .
noremap $p $
noremap %y %
noremap ^f ^
noremap &g &
noremap *c *
noremap (r (
noremap )l )
noremap! !' !
noremap! @, @
noremap! #. #
noremap! $p $
noremap! %y %
noremap! ^f ^
noremap! &g &
noremap! *c *
noremap! (r (
noremap! )l )

" Screen is tiny, so make adjustments
set laststatus=1 " Don't show status line if this is the only window
set showtabline=0 " I use this only for zoom, and I want that extra line!
autocmd User AirlineAfterInit set laststatus=1 " airline messes this up
set scrolloff=0

" FZF goes faster in full-screen mode for some reason
nnoremap <leader>q :Buffers!<cr>
nnoremap <leader>f :Files!<cr>
nnoremap <leader>h :History!<cr>

" Hide continuations
let &showbreak=''

" Help limelight
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" Set color scheme
colorscheme default-termux

" No bell, visual or otherwise
set vb t_vb=

set ttimeoutlen=10
