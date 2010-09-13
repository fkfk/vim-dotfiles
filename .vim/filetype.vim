if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.scala setfiletype scala
  au! BufRead,BufNewFile *.go setfiletype go
  "Git$BMQ(B
  au BufNewFile,BufRead COMMIT_EDITMSG set filetype=git
  "Flex(*.as$B$H(B*.mxml)$BMQ(B
  au BufNewFile,BufRead *.as set filetype=actionscript
  au BufNewFile,BufRead *.mxml set filetype=mxml
  au FileType actionscript :set dictionary=~/.vim/dict/actionscript3.dict
augroup END
