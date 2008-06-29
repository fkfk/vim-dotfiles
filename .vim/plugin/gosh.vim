" gosh.vim -- UJIHISA, Tatsuhiro
"   * type ,go then gosh runs
"   * you have to set mapleader on your .vimrc
"     for example: let mapleader=","
command! Gosh :call <SID>Gosh()

nmap <leader>go :Gosh<cr>

func! s:Gosh()
  let cmd = join(getline(1, line("$")), "\n")
  exe 'bo sp [gosh]'
  call eval("append(0, split(system('echo \"'.cmd.'\" | gosh'), '\n'))")

  setlocal nomodifiable
  setlocal nobuflisted
  setlocal nonumber
  setlocal noswapfile
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal noshowcmd
  setlocal nowrap
  noremap <buffer> <silent> q :close<cr>
endfunc
