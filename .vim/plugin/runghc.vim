" runghc.vim -- UJIHISA, Tatsuhiro
"   * type ,rh then runghc runs
"   * you have to set mapleader on your .vimrc
"     for example: let mapleader=","
"   * you have to install ghc
command! Runghc :call <SID>Runghc()

nmap <leader>rh :Runghc<cr>

func! s:Runghc()
  let code = join(getline(1, line("$")), "\n")
  let tmpfile = "/tmp/runghc-vim-tmpfile.hs"
  exe 'bo sp [runghc]'
  call eval("append(0, split(system('echo \"'.code.'\" > '.tmpfile.' && runghc '.tmpfile), '\n'))")

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
