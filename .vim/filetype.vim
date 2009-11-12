if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.scala setfiletype scala
  au! BufRead,BufNewFile *.go setfiletype go
augroup END
