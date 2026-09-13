if exists(':Censor') != 2
  finish
endif

let b:undo_ftplugin = 'unlet b:censor_pattern'

" Leave first and last letter visible, unless we're typing the word. Also,
" leave only the first letter visible for two-letter words.
"
" Note that the NFA regex engine doesn't match the current character right,
" so this regex explicitly selects the legacy backtracking engine.
" See " |two-engines|
let b:censor_pattern='\%#=1\v\w\zs%(\w>|\S+%(%#|\ze\w))'

" \%#=1 - force using the old regex engine
" \v    - very magic (reduces escaping later)
" \w    - word character
" \zs   - start the match
" %(    - unnamed group
"  \w>  - word character at the end of a word (matches only in two-letter
"         words)
" |     - alternative
"  \S+  - one or more non-whitespace chars
"  %(   - unnamed groups
"   %#  - current cursor position, so we don't show the latest letter of the
"         word we're typing
"  |    - alternative
"   \ze - end the match
"   \w  - word character
"  )    - end unnamed group
" )     - end unnamed group

let g:censor_replacement_char='·'
