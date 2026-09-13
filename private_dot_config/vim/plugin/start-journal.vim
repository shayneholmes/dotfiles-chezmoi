" Commands to provision a journal page and start writing

noremap <script> <Plug>JournalingStart <SID>StartJournaling
noremap <script> <SID>StartJournaling :call <SID>StartJournaling()<CR>

command! StartJournaling call <SID>StartJournaling()
command! StartJournalingYesterday call <SID>StartJournalingYesterday()
command! StartJournalingHere call <SID>StartJournalingHere()

let s:writeOnly=0

function! s:StartJournaling()
  call <SID>OpenFile()
  call <SID>StartJournalingHere()
endf

function! s:StartJournalingYesterday()
  const yesterday = localtime()-24*3600
  call <SID>OpenFile(yesterday)
  call <SID>StartJournalingHere(yesterday)
endf

function! s:StartJournalingHere(time = localtime())
  call <SID>FormatFile(a:time)
  call <SID>RemoveDistractions()
  call <SID>InitJailedMode()
  call <SID>NoPinkies()
  nnoremap <script> <silent> <leader>a :call <SID>appendAtEnd()<CR>
  call <SID>appendAtEnd()
endf

function! s:appendAtEnd()
  norm G
  startinsert!
endf

function! s:OpenFile(time = localtime())
  try
    silent execute 'edit' "journal-" . strftime("%F", a:time) . ".txt"
  catch /^Vim\%((\a\+)\)\=:E37/	" catch error E37
    " File is already active, so don't reload it, but keep going
  endtry
endf

function! s:FormatFile(time = localtime())
  if line('$') == 1 && col([line('$'), '$']) == 1 " empty file
    call <SID>InsertJournalHeaders(a:time)
  endif
  if col([line('$'), '$']) > 1
    " The last line has text; make a new paragraph
    let failed = append(line('$'), ["", ""])
  endif
endf

function! s:InsertJournalHeaders(time = localtime())
  let header = []
  call add (header, strftime("%A, %-e %B %Y", a:time))
  call add (header, "")
  let failed = append(0, header)
endf

function! s:RemoveDistractions()
  augroup NoDistractions
    autocmd!
    " Clear the status line when entering insert mode
    autocmd InsertEnter <buffer> echon
    " Clear the status line when saving a file
    autocmd BufWritePost <buffer> echon
    " Refresh the ruler when speedometer updates.
    autocmd! User SpeedometerUpdate echon
  augroup END
  setl laststatus=1 " Don't show status line if this is the only window
  setl noshowcmd noshowmode " Clean up status line
  " Hide tildes at the end of the file
  set fillchars+=eob:\ ,

  " Put file size in ruler
  setl ruler
  let &rulerformat = "%#Special#%=%{SpeedometerValue()} %{" . expand('<SID>') ."CoarseFileSize(" . expand('<SID>') ."FileSizeBytes())} %{" . expand('<SID>') ."FileSizeBlinker()}"

  " Set mappings for blinker changing
  inoremap <silent> <C-b> <C-o>:IncrementBlinker<CR>
  nnoremap <silent> <C-b> :IncrementBlinker<CR>
endf

function! <SID>FileSizeBytes()
  return (line2byte('$') + len(getline('$')))
endf


" Blinkers
let s:blinkers = []
call add(s:blinkers, "⠁⠂⠄⡀⡈⡐⡠⣀⣁⣂⣄⣌⣔⣤⣥⣦⣮⣶⣷⣿⡿⠿⢟⠟⡛⠛⠫⢋⠋⠍⡉⠉⠑⠡⢁") " crumble
call add(s:blinkers, "⠁⠂⠄⠂")
call add(s:blinkers, ' ▁▂▃▄▅▆▇█') " upward dial
call add(s:blinkers, '←↖↑↗→↘↓↙') " spinning arrows
call add(s:blinkers, '⢄⢂⢁⡁⡈⡐⡠') " walking dots
call add(s:blinkers, "┤┘┴└├┌┬┐")
call add(s:blinkers, '⣶⣧⣏⡟⠿⢻⣹⣼') " swimmer clockwise
call add(s:blinkers, "⣾⣽⣻⢿⡿⣟⣯⣷") " ersatz swimmer
call add(s:blinkers, '▖▘▝▗') " four corners
call add(s:blinkers, '▌▀▐▄') " block spinner
call add(s:blinkers, '▏▎▍▌▋▊▉▊▋▌▍▎') " slide from left
call add(s:blinkers, '🌑🌒🌓🌔🌕🌖🌗🌘') " moony
call add(s:blinkers, '🕛🕐🕑🕒🕓🕔🕕🕖🕗🕘🕙🕚') " time flies

let s:blinkerIndex=-1

function! <SID>IncrementBlinker()
  let s:blinkerIndex=(s:blinkerIndex+1) % len(s:blinkers)
  const l:blinkerString = s:blinkers[s:blinkerIndex]
  let s:blinkerFrames = split(l:blinkerString, '\zs') " split into chars
  let s:blinkerFrameCount = len(s:blinkerFrames)
endfunction

call <SID>IncrementBlinker()

command! IncrementBlinker call <SID>IncrementBlinker()

function! <SID>FileSizeBlinker()
  let bytes = line2byte('$') + len(getline('$'))
  let frameIndex = bytes % s:blinkerFrameCount
  return s:blinkerFrames[frameIndex]
endf

" Print the file size to the nearest 100 characters: Tells roughly how big
" the file is getting without changing on every keystroke.
function! <SID>CoarseFileSize(sizeBytes)
  return printf('%.1f', a:sizeBytes/1024.0)
endf

" Print rough file size using a more graphical mechanism
const s:size_unit_bytes = 4*1024.0
const s:size_indicators = split(' ▂▄▆█', '\zs')
const s:size_indicators_len = len(s:size_indicators)
const s:size_indicators_full = s:size_indicators[s:size_indicators_len-1]
function! <SID>CoarseFileSizeGraphical(sizeBytes)
  const sizeUnits = a:sizeBytes/s:size_unit_bytes
  const fullUnits = float2nr(sizeUnits)
  const fractionalUnits = float2nr((sizeUnits - fullUnits) * s:size_indicators_len)
  return s:size_indicators[fractionalUnits] . repeat(s:size_indicators_full, fullUnits)
endf

function! s:InitJailedMode()
  " Disable moving the cursor in insert mode
  inoremap <buffer> <Up> <Nop>
  inoremap <buffer> <Down> <Nop>
  inoremap <buffer> <Left> <Nop>
  inoremap <buffer> <Right> <Nop>
  " Leave <S-Up> alone if already mapped
  if empty(mapcheck("<S-Up>", "i"))
    inoremap <buffer> <S-Up> <Nop>
  endif
  inoremap <buffer> <S-Down> <Nop>
  inoremap <buffer> <S-Left> <Nop>
  inoremap <buffer> <S-Right> <Nop>
  inoremap <buffer> <C-Up> <Nop>
  inoremap <buffer> <C-Down> <Nop>
  inoremap <buffer> <C-Left> <Nop>
  inoremap <buffer> <C-Right> <Nop>
  inoremap <buffer> <Home> <Nop>
  inoremap <buffer> <End> <Nop>
  inoremap <buffer> <kHome> <Nop>
  inoremap <buffer> <kEnd> <Nop>
  inoremap <buffer> <S-Home> <Nop>
  inoremap <buffer> <S-End> <Nop>
  inoremap <buffer> <C-Home> <Nop>
  inoremap <buffer> <C-End> <Nop>
  inoremap <buffer> <PageUp> <Nop>
  inoremap <buffer> <PageDown> <Nop>
  inoremap <buffer> <kPageUp> <Nop>
  inoremap <buffer> <kPageDown> <Nop>
  inoremap <buffer> <S-PageUp> <Nop>
  inoremap <buffer> <S-PageDown> <Nop>
  inoremap <buffer> <C-PageUp> <Nop>
  inoremap <buffer> <C-PageDown> <Nop>

  " Ignore scrolling from termux
  noremap <ScrollWheelUp> <Nop>
  inoremap <ScrollWheelUp> <Nop>
  noremap <ScrollWheelDown> <Nop>
  inoremap <ScrollWheelDown> <Nop>

  " Disable mouse entirely
  set mouse=

  " Disable delete
  inoremap <buffer> <Del> <Nop>

  if s:writeOnly
    " Write-only mode: No backspace, only append
    inoremap <buffer> <BS> <Nop>
    inoremap <buffer> <C-w> <Nop>
  endif
endf


" Set up commands so that I don't have to use my pinkies to write.
function! s:NoPinkies()
  " Delete a word
  noremap! cg <c-w>
  " Delete a sentence (in a new undo scope)
  noremap! <silent> cb <c-g>u<c-o>d(<c-o>x
  " Capitalize some common words
  inoreabbrev i I
  inoreabbrev i'd I'd
  inoreabbrev i'll I'll
  inoreabbrev i'm I'm
  inoreabbrev i've I've
  augroup nopinkies
    autocmd!
    " Capitalize starts of sentences
    autocmd InsertCharPre <buffer> call <SID>uppercase()
  augroup END
endfunction

" If this function is called during InsertCharPre, it will alter the character
" to be uppercase after the end of a sentence, or at a new paragraph.
function! s:uppercase()
  if search('\v([^.][.!?][)"\[]?[ \n]+|\n\n)[\[("]?%#', 'bcnW') != 0
    let v:char = toupper(v:char)
  endif
endfunction
