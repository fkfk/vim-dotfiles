"入力周り
set backspace=2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set noautoindent
set nowritebackup
set tags=$HOME/.tags
set kp=:help
let mapleader = ","

"表示回り
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

if has('win32')
  set directory=$TMP
  set backupdir=$TMP
else
  set directory=/tmp
  set backupdir=/tmp
endif

if has('kaoriya')
  let s:ruby_libruby = system('ruby -rrbconfig -e "print Config::CONFIG[\"libdir\"] + \"/\" + Config::CONFIG[\"LIBRUBY\"]"')
  if filereadable(s:ruby_libruby)
    let $RUBY_DLL = s:ruby_libruby
  endif
endif

" use pathogen
filetype off
let g:pathogen_disabled = []
if !has('python')
  call add(g:pathogen_disabled, 'blogit')
  if v:version < '703'
    call add(g:pathogen_disabled, 'gundo')
  endif
endif
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
set helpfile=$VIMRUNTIME/doc/help.txt

syntax on
filetype on
filetype indent on
filetype plugin on

"neocomplcacheの設定
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_auto_completion_start_length = 1
let g:neocomplcache_min_keyword_length = 3
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_snippets_dir = '$HOME/.vim/snippets'

if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" <TAB>で補完
inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
" snippetsの展開
imap <expr><C-e> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-e>"
smap <expr><C-e> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-e>"

"VimShellの設定
noremap <silent> <C-x>s :VimShell<CR>
let g:vimshell_prompt = '> '

"ref.vimの設定
let g:ref_refe_cmd = "refe187"
let g:ref_phpmanual_path = $HOME . "/.vim/manual/phpmanual"

"tabpage周り
noremap <C-x>tn :tabnew<CR>
noremap <C-x>tq :tabclose<CR>
noremap <C-x>to :tabonly<CR>
noremap <C-l> gt
noremap <C-h> gT

" vnew,new用マッピング
noremap <C-x>v :vnew<CR>
noremap <C-x>n :new<CR>

" sp,vsp用マッピング
noremap <C-x>V :vsp<CR>
noremap <C-x>S :sp<CR>

" ウィンドウの移動
noremap <Leader>k <C-w>K
noremap <Leader>j <C-w>J
noremap <Leader>h <C-w>H
noremap <Leader>l <C-w>L
noremap <Leader>T <C-w>T

" etc
noremap <C-x>r :source $HOME/.vimrc<CR>
noremap <Space>d :bdelete<CR>
noremap <Space>D :bdelete!<CR>
noremap <Space>t :set tags=$HOME/.tags/
noremap <ESC><ESC> :nohlsearch<CR>

" VCSCommand
noremap <silent> <Leader>vd :VCSDiff<CR>
noremap <silent> <Leader>va :VCSAdd<CR>
noremap <silent> <Leader>vc :VCSCommit<CR>
noremap <silent> <Leader>vs :VCSStatus<CR>

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
" To deal with Japanese language.
if $ENV_WORKING ==# 'summer'
  set encoding=japan
elseif has('win32')
  set encoding=cp932
else
  set encoding=utf-8
endif

if has('iconv')
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
endif

if $ENV_ACCESS ==# 'summer'
  set termencoding=cp932
elseif has('gui_macvim')
  " E617 - It's not possible to change 'termencoding' in MacVim.
else  " fallback
  set termencoding=  " same as 'encoding'
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

" eregex.vim
AlterCommand s S
AlterCommand %s %S

"QuickRun用設定
let g:quickrun_config = {}
if has("clientserver")
  let g:quickrun_config = {'*': {'runmode': 'async:remote:vimproc'},}
else
  let g:quickrun_config = {'*': {'runmode': 'async:vimproc'},}
endif
let g:quickrun_config.javascript = {'command': 'node'}

noremap <silent> <C-r> :QuickRun<CR>

"gundo用設定
if v:version < '703'
  noremap <silent> <C-u> :undolist<CR>
else
  nnoremap <silent> <C-u> :GundoToggle<CR>
endif

" unite用設定
noremap <silent> <C-B> :Unite buffer<CR>
noremap <silent> <C-N> :UniteWithBufferDir -buffer-name=files file<CR>
noremap <silent> <C-P> :Unite file_mru<CR>
noremap <silent> <C-A> :UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
