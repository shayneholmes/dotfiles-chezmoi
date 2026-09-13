" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  autocmd BufRead,BufNewFile *.eyaml setfiletype yaml
  autocmd BufRead,BufNewFile */Notational\ Data/*.txt setfiletype markdown " Interpret nvAlt files as markdown
  autocmd BufRead,BufNewFile */notes/*.txt setfiletype markdown " Interpret nvAlt files as markdown
augroup END
