if &cp || (exists('g:loaded_tabzoom') && g:loaded_tabzoom)
  finish
endif
let g:loaded_tabzoom = 1

" Zoom window by opening in new tab
function! TabZoom()
  if tabpagewinnr(tabpagenr(),'$') == 1
    if tabpagenr() == 1
      echo "Can't unzoom: This is the first tab!"
    else
      tabclose
    endif
  else
    tab split
  endif
endfunction

command! TabZoom call TabZoom()
