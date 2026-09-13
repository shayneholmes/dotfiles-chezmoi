let s:base_dir = resolve(expand("<sfile>:p:h"))
let s:proj_jsn = s:base_dir . "/projectionist_heuristics.json"

function! s:setProjections()
  let l:json = readfile(s:proj_jsn)
  let l:dict = projectionist#json_parse(l:json)
  let g:projectionist_heuristics = l:dict
endfunction

call s:setProjections()

" Set up mappings on projectionist load

augroup projectionist_after
  autocmd!
  autocmd User ProjectionistActivate call s:activate()
augroup end

function! s:activate() abort
  for [root, value] in projectionist#query('type')
    if value == 'source'
      nnoremap <leader>es :Esource<cr>
    elseif value == 'test'
      nnoremap <leader>et :Etest<cr>
    elseif value == 'mock'
      nnoremap <leader>em :Emock<cr>
    endif
  endfor
  nnoremap <silent> <Leader>a :A<cr>
endfunction
