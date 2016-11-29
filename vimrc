" flobal
let s:default_config = {
\   'encodings': {
\     'encoding': '',
\     'termencoding': ''
\   },
\   'rc': {
\     'basedir': expand('<sfile>:p:h'),
\     'scriptsdir': '',
\     'lazyconfig': {}
\   }
\ }

let s:merged_config = {}
call extend(s:merged_config, s:default_config)
call extend(s:merged_config, get(g:, 'myvimrc', {}))
let g:myvimrc = s:merged_config
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
