scriptencoding utf-8

setlocal breakindent
setlocal breakindentopt=shift:0,min:20
setlocal iskeyword=@,48-57,_,192-255,',.,-,; " include word separators
let b:undo_ftplugin = 'set bri< briopt< isk<|
      \ unlet
      \ b:censor_highlight_def
      \ b:censor_pattern
      \ b:censor_replacement_char |
      \ autocmd! TextSyntax | augroup! TextSyntax'

" Censor some symbols in the middle of words.
" Note: While we're typing, we will type some symbols that will likely end up
" being in the middle of the word; censor these right after they're typed,
" even though they're at the end of a word while being typed.
let s:midword_chars="-'"
let b:censor_pattern=
      \ '\v[A-Za-z0-9]+%('
      \ .'['.s:midword_chars.']+[A-Za-z0-9]+)*'
      \ .'%(['.s:midword_chars.']+%#)?'

" Leave first and last letter visible, unless we're typing the word
" Note that the NFA regex engine doesn't match this right, so this regex
" explicitly selects the legacy backtracking engine. See |two-engines|
" let b:censor_pattern='\%#=1\v\w\zs\S+%(%#|\ze\w)'

" Censor multiple words together
" let b:censor_pattern='\v\S+%(\s\S+)*'

" Leave the first letter open
" let b:censor_pattern='\w\zs\w\+'

let b:censor_highlight_def='NONE'
let b:censor_replacement_char='x'

" Show upper- and lower-case as different
function! s:censor_enter()
  syn match CensoredChar '[A-Z]' contained conceal cchar=X
  syn match CensoredChar '[0-9]' contained conceal cchar=#
endfunction

augroup TextSyntax
  autocmd! User CensorEnter call <SID>censor_enter()
augroup END
