" :q quits even when Goyo is active
" based on https://github.com/junegunn/goyo.vim/wiki/Customization#ensure-q-to-quit-even-when-goyo-is-active
function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd vimrc QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  " Quit Vim if this is the only remaining buffer
  if b:quitting && winnr('$') == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! vimrc User GoyoEnter call <SID>goyo_enter()
autocmd! vimrc User GoyoLeave call <SID>goyo_leave()
