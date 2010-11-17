"入力周り
set backspace=2
set tabstop=2
set softtabstop=2
set shiftwidth=2
"インデントにタブを用いなければならないのでコメントアウト
"set expandtab
set noautoindent
set nowritebackup
set tags=$HOME/.tags
set kp=:help

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
set statusline=%<%f\ %=\%m%r%y%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ \ %l\/%L,%c%V%8P[%n]

set incsearch
set nocompatible
set hidden

set directory=/tmp
set backupdir=/tmp

syntax on
filetype on
filetype indent on
filetype plugin on

"Rubyのオムニ補完を設定(ft-ruby-omni)
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

"neocomplcacheの設定
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_auto_completion_start_length = 1
let g:neocomplcache_min_keyword_length = 3
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1

if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'


"VimShellの設定
"現バージョンでは動かないらしいのでコメントアウト
"let g:VimShell_EnableInteractive = 1

"ref.vimの設定
let g:ref_refe_cmd = "refe187"
let g:ref_phpmanual_path = $HOME . "/.vim/manual/phpmanual"

"tabpage周り
noremap <C-x>tn :tabnew<CR>
noremap <C-x>tq :tabclose<CR>
noremap <C-x>to :tabonly<CR>
noremap <C-l> gt
noremap <C-h> gT

" <TAB>で補完できるよう設定
inoremap <tab> <C-n>

" vnew,new用マッピング
noremap <C-x>v :vnew<CR>
noremap <C-x>n :new<CR>

" sp,vsp用マッピング
noremap <C-x>V :vsp<CR>
noremap <C-x>S :sp<CR>

" etc
noremap <C-x>r :source $HOME/.vimrc<CR>
noremap <Space>d :bdelete<CR>
noremap <Space>D :bdelete!<CR>
noremap <Space>t :set tags=$HOME/.tags/
noremap <C-x>u :undolist<CR>

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

" TabpageCD
" Reference: kana's vimrc
call altercmd#load()

command! -complete=customlist,s:complete_cdpath -nargs=? TabpageCD
\ execute 'cd' fnameescape(<q-args>)
\| let t:cwd = getcwd()
 
function! s:complete_cdpath(arglead, cmdline, cursorpos)
    return split(globpath(&cdpath,
            \ join(split(a:cmdline, '\s', 1)[1:], ' ') . '*/'),
            \ "\n")
endfunction
 
AlterCommand cd TabpageCD
 
command! CD silent exe "TabpageCD " . expand('%:p:h')
 
augroup vimrc-autocmd
    autocmd VimEnter,TabEnter *
    \ if !exists('t:cwd')
    \| let t:cwd = getcwd()
    \| endif
    \| execute 'cd' fnameescape(t:cwd)
augroup END

"QuickRun用設定
noremap <silent> <C-r> :QuickRun<CR>
