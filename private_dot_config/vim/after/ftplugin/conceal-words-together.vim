if exists(':Censor') != 2
  finish
endif

let b:undo_ftplugin = 'unlet b:censor_pattern'

" Censor multiple words together
let b:censor_pattern='\v\S+%(\s\S+)*'
