if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.scala setfiletype scala
  au! BufRead,BufNewFile *.go setfiletype go
  "Git用
  au BufNewFile,BufRead COMMIT_EDITMSG set filetype=git
  "Flex(*.asと*.mxml)用
  au BufNewFile,BufRead *.as set filetype=actionscript
  au BufNewFile,BufRead *.mxml set filetype=mxml
  au FileType actionscript :set dictionary=~/.vim/dict/actionscript3.dict
augroup END
