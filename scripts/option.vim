syntax on
filetype on
filetype indent on
filetype plugin on

"入力周り
set backspace=2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set noautoindent
set nowritebackup
set nofixeol
set fileformats=unix,dos,mac
set tags=$HOME/.tags
set kp=:help

set nottimeout

"表示回り
set wrap
set ruler
set ambiwidth=double
set laststatus=2
set foldmethod=marker
set showtabline=2

set list
set listchars=tab:>\ ,trail:~,extends:>,precedes:<

set incsearch
set nocompatible
set hidden

if has('win32')
  set directory=$TMP
  set backupdir=$TMP
  set undodir=$TMP
else
  set directory=/tmp
  set backupdir=/tmp
  set undodir=/tmp
endif

" zsh っぽい補完に
set wildmode=longest,list

set autoread

" 補完候補を表示する
set wildmenu

"横分割時は下へ、縦分割時は右へ新しいウィンドウが開くようにする
set splitbelow
set splitright

"<C-x> <C-a>で増減させるもの
set nrformats=alpha,hex

set breakindent
set breakindentopt=shift:2,sbr
set showbreak=>

if g:myvimrc.encodings.encoding != ""
  let &encoding = g:myvimrc.encodings.encoding
elseif has('win32')
  " vim-kaoriyaで内部エンコーディングがutf-8の場合
  if has('kaoriya') && glob($VIM."/switches/enabled/utf-8.vim") != ""
    set encoding=utf-8
  else
    set encoding=cp932
  endif
else
  set encoding=utf-8
endif

if has('iconv')
  let s:enc_euc_list = ['euc-jp']
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'

  " Does iconv support JIS X 0213 ?
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc_list = ['euc-jsx0231'] + s:enc_euc_list
  endif

  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc_list = ['eucjp-ms'] + s:enc_euc_list
  endif

  let s:enc_euc = join(s:enc_euc_list, ',')
  if count(s:enc_euc_list, 'eucjp-ms') != 0 || count(s:enc_euc_list, 'euc-jisx0213') != 0
    let s:enc_jis = 'iso-2022-jp-3'
  endif

  " Make fileencodings
  let s:fileencodings = ['ucs-bom']
  if &encoding !=# 'utf-8'
    let s:fileencodings += ['ucs-2le', 'ucs-2']
  endif
  let s:fileencodings += [s:enc_jis]

  if &encoding ==# 'utf-8'
    let s:fileencodings += s:enc_euc_list + ['cp932']
  elseif &encoding =~# '^euc\%(-jp\|-jisx0213\|jp-ms\)$'
    let &encoding = s:enc_euc
    let s:fileencodings += ['utf-8', 'cp932']
  else  " cp932
    let s:fileencodings += ['utf-8'] + s:enc_euc_list
  endif
  let &fileencodings = join(s:fileencodings + [&encoding], ',')

  unlet s:fileencodings
  unlet s:enc_euc_list
  unlet s:enc_euc
  unlet s:enc_jis
endif

if !has('nvim')
  if g:myvimrc.encodings.termencoding != ""
    let &termencoding = g:myvimrc.encodings.termencoding
  elseif has('kaoriya') && ! has('gui') && glob($VIM."/switches/enabled/utf-8.vim") != ""
    set termencoding=cp932
  elseif has('gui_macvim')
    " E617 - It's not possible to change 'termencoding' in MacVim.
  else  " fallback
    set termencoding=  " same as 'encoding'
  endif

  " For snippet_complete marker.
  if has('conceal')
    set conceallevel=2 concealcursor=i
  endif
endif

" for ripgrep
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
