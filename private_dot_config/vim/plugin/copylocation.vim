" Copy location of cursor to clipboard
nnoremap <Plug>CopyLocation :echom "foo"<CR>:call <SID>CopyLocation()<CR>

func! s:CopyLocation()
  let l:file=@%
  let l:pos=getpos('.')
  let l:line=l:pos[1]
  let l:location=printf('%s:%d', l:file, l:line)
  echom l:location

  let l:register = '"'
  if has('clipboard_working')
    let l:register = '*'
  endif
  call setreg(l:register, l:location)
endfunc
