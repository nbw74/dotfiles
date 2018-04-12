au BufRead *-prod.yml  call AutoreadDuctTape()
au BufRead *-stage.yml call AutoreadDuctTape()
au BufRead *-test.yml  call AutoreadDuctTape()

function! AutoreadDuctTape()
    setlocal autoread
    au BufEnter,CursorHold,CursorHoldI * checktime
    autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
endfunction
