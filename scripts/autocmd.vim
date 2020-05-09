au FileType php EnablePHPFolds

augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r
  autocmd BufWritePre * endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END

" for quickfix
autocmd QuickFixCmdPost *grep* cwindow

" ref.vim
au FileType perl setl kp=:Ref\ perldoc
au FileType php setl kp=:Ref\ phpmanual
au FileType python setl kp=:Ref\ pydoc
au FileType ruby setl kp=:Ref\ refe

" golang
augroup golang
  au!
  "au FileType go setlocal sw=4 ts=4 sts=4 noet
augroup END

"autocmd VimEnter * call dein#update()
