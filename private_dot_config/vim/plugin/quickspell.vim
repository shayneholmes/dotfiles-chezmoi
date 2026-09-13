" Quick spelling fix outside spelling mode
nnoremap <Plug>QuickspellFix <silent> :call <SID>QuickSpellFix()<CR>

func! s:QuickSpellFix()
  let l:hadspell = &l:spell
  let &l:spell = 1

  normal! 1z=
  let &l:spell = l:hadspell
endfunc
