" Only do this when not done yet for this buffer
if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setl linebreak
setl foldmethod=expr
setl foldexpr=getline(v\:lnum)=~'\\d\\{4}$'?'>1'\:'='

