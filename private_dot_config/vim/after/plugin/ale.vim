let g:ale_linters = {
      \ 'javascript': ['eslint', 'tsserver'],
      \ 'typescript': ['eslint', 'tsserver'],
      \ 'markdown': ['eslint', 'prettier'],
      \ 'java': [],
      \}
if !runningOnPhone
  let g:ale_sign_error = '●' " Less aggressive than the default '>>'
endif
let g:ale_sign_warning = '.'
let g:ale_sign_column_always = 1 " Less distracting when opening a new file
highlight SignColumn NONE " Make the margin invisible
nnoremap yoe :ALEToggleBuffer<CR>
nnoremap <Leader>l :ALEFix eslint<CR>
