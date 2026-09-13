if get(b:, 'ftplugin_help_toggle_loaded', 0)
  finish
end

let b:ftplugin_help_toggle_loaded = 1

function! <SID>toggle_filetype()
  if &filetype == 'text'
    setf help
  else
    setf text
  endif
endfunction

nnoremap <buffer> <Plug>FtpluginHelpToggle :call <SID>toggle_filetype()<CR>
nmap <buffer> <Leader>r <Plug>FtpluginHelpToggle
