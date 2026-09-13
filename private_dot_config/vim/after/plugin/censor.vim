if exists(':Censor') != 2
  finish
endif

" global censor options
let g:censor_highlight_def='NONE'
let g:censor_replacement_char='·'

function! s:censor_enter()
  if !exists('s:peektimer')
    nnoremap <buffer> <silent> <C-S> :call <SID>peek()<CR>
    inoremap <buffer> <expr> <C-S> <SID>peek()
  endif
endfunction

function! s:censor_leave()
  if !exists('s:peektimer')
    nunmap <buffer> <C-S>
    iunmap <buffer> <C-S>
  endif
endfunction

autocmd! vimrc User CensorEnter call <SID>censor_enter()
autocmd! vimrc User CensorLeave call <SID>censor_leave()
nnoremap <silent> <Leader>c :Censor<CR>
nnoremap <silent> yoc :Censor<CR>

let s:peekms=600

function! s:peekend(timer)
  Censor
  unlet s:peektimer
endfunction

let s:peekendref = funcref("s:peekend")

function! s:peek()
  if exists('s:peektimer')
    call timer_stop(s:peektimer)
    call s:peekend(s:peektimer)
    return ''
  endif

  let s:peektimer = timer_start(s:peekms, s:peekendref)
  Censor
  return ''
endfunction
