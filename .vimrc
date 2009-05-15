"入力周り
set backspace=2
set tabstop=2
set softtabstop=2
set expandtab
set noautoindent
set nowritebackup

"表示回り
set enc=utf-8
set fenc=utf-8
set fencs=iso-2022-jp,enc-jp,cp932
set wrap
set ruler
set ambiwidth=double
set laststatus=2
set foldmethod=marker

set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<

" ステイタス行に文字コードと改行コードを表示。
set statusline=%<%f\ %m%r%h%w%=%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ \ %l,%c%V%8P

set incsearch
set nocompatible
set hidden

syntax on
filetype on
filetype indent on
filetype plugin on

"Rubyのオムニ補完を設定(ft-ruby-omni)
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

"autocomplpopを無効化
let g:AutoComplPop_NotEnableAtStartup = 1

"nocomplcacheの設定
let g:NeoComplCache_EnableAtStartup = 1
let g:NeoComplCache_KeywordCompletionStartLength = 1
let g:NeoComplCache_MinKeywordLength = 3
let g:NeoComplCache_MinSyntaxLength = 3
let g:NeoComplCache_SmartCase = 1
let g:NeoComplCache_TagsAutoUpdate = 1
let g:NeoComplCache_TryKeywordCompletion = 1

" <TAB>で補完できるよう設定
inoremap <tab> <c-n>

" rails.vim
let g:rails_level=4
let g:rails_default_file="app/controllers/application.rb"

" zsh っぽい補完に
set wildmode=longest,list

set autoread

" 補完候補を表示する
set wildmenu

"横分割時は下へ、縦分割時は右へ新しいウィンドウが開くようにする
set splitbelow
set splitright

"<C-x> <C-a>で増減させるもの
set nrformats="hex"

"Git用
let git_diff_spawn_mode=1
autocmd BufNewFile,BufRead COMMIT_EDITMSG set filetype=git

"Flex(*.asと*.mxml)用
autocmd BufNewFile,BufRead *.as set filetype=actionscript
autocmd BufNewFile,BufRead *.mxml set filetype=mxml
autocmd FileType actionscript :set dictionary=~/.vim/dict/actionscript3.dict

"エンコーディング via kana/dot.vimrc
if !exists('did_encoding_settings') && has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'

  " Does iconv support JIS X 0213 ?
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213,euc-jp'
    let s:enc_jis = 'iso-2022-jp-3'
  endif

  " Make fileencodings
  let &fileencodings = 'ucs-bom'
  if &encoding !=# 'utf-8'
    let &fileencodings = &fileencodings . ',' . 'ucs-2le'
    let &fileencodings = &fileencodings . ',' . 'ucs-2'
  endif
  let &fileencodings = &fileencodings . ',' . s:enc_jis

  if &encoding ==# 'utf-8'
    let &fileencodings = &fileencodings . ',' . s:enc_euc
    let &fileencodings = &fileencodings . ',' . 'cp932'
  elseif &encoding =~# '^euc-\%(jp\|jisx0213\)$'
    let &encoding = s:enc_euc
    let &fileencodings = &fileencodings . ',' . 'utf-8'
    let &fileencodings = &fileencodings . ',' . 'cp932'
  else  " cp932
    let &fileencodings = &fileencodings . ',' . 'utf-8'
    let &fileencodings = &fileencodings . ',' . s:enc_euc
  endif
  let &fileencodings = &fileencodings . ',' . &encoding

  unlet s:enc_euc
  unlet s:enc_jis

  let did_encoding_settings = 1
endif

"quickrun.vimの設定
let g:mapleader=" "
""0〜9に割り当てるコマンドを順番に記述する
let g:quicklaunch_commands = [
  \ '',
  \ 'git status',
  \ 'git log',
  \ 'git add *',
  \ 'git pull',
  \ 'git svn dcommit'
  \ ]
