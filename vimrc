" global
let g:myvimrc = get(g:, 'myvimrc', {})
let g:myvimrc.encodings = get(g:, 'myvimrc.encodings', {})
let g:myvimrc.encodings.encoding = get(g:, 'myvimrc.encodings.encoding', '')
let g:myvimrc.encodings.termencoding = get(g:, 'myvimrc.encodings.termencoding', '')
let g:myvimrc.rc = get(g:, 'myvimrc.rc', {})
let g:myvimrc.rc.basedir = get(g:, 'myvimrc.rc.basedir', expand('<sfile>:p:h'))
let g:myvimrc.rc.scriptsdir = get(g:, 'myvimrc.rc.scriptsdir', g:myvimrc.rc.basedir . '/.vim/scripts')

function! g:myvimrc.source(name)
  let fpath = g:myvimrc.rc.scriptsdir . '/' . a:name
  if filereadable(fpath)
    execute 'source ' . fpath
  endif
endfunction

if &compatible
  set nocompatible
endif

augroup MyAutoCmd
  autocmd!
augroup END

call g:myvimrc.source('dein.vim')
call g:myvimrc.source('option.vim')
call g:myvimrc.source('map.vim')
call g:myvimrc.source('functions.vim')
call g:myvimrc.source('plugin_config.vim')
call g:myvimrc.source('autocmd.vim')
call g:myvimrc.source('util.vim')
