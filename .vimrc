"入力周り
set backspace=2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set noautoindent
set nowritebackup
set fileformats=unix,dos,mac
set tags=$HOME/.tags
set kp=:help
let mapleader = " "

"表示回り
set wrap
set ruler
set ambiwidth=double
set laststatus=2
set foldmethod=marker

set list
set listchars=tab:>\ ,trail:~,extends:>,precedes:<

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

" use dein.vim
filetype off

if &compatible
  set nocompatible
endif

augroup MyAutoCmd
  autocmd!
augroup END

let s:dein_dir = $HOME . '/.vim/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let &rtp = &rtp .",". s:dein_repo_dir

let g:dein#install_progress_type = 'title'
let g:dein#install_log_filename = s:dein_dir . '/install.log'

if !exists('g:dein_toml_list')
  let g:dein_toml_list = []
endif
let g:dein_toml_list += [s:dein_dir . '/config.toml', s:dein_dir . '/config_local.toml']
let s:dein_rc_list = [$MYVIMRC] + g:dein_toml_list

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, s:dein_rc_list)
  for toml in g:dein_toml_list
    if filereadable(toml)
      call dein#load_toml(toml)
    endif
  endfor
  call dein#end()
  call dein#save_state()

  if dein#check_install()
    call dein#install()
  endif
endif

silent! execute 'helptags' s:dein_repo_dir . '/doc/'

syntax on
filetype on
filetype indent on
filetype plugin on

" Windowsでscpを使う場合pscp.exeを用いる
if has('win32') && !exists('g:netrw_scp_cmd')
  let g:netrw_scp_cmd="c:\\opt\\putty\\pscp.exe -q"
endif

if has('kaoriya')
  try
    let s:ruby_libruby = vimproc#system('ruby -rrbconfig -e "print Config::CONFIG[\"libdir\"] + \"/\" + Config::CONFIG[\"LIBRUBY\"]"')
  catch
    let s:ruby_libruby = system('ruby -rrbconfig -e "print Config::CONFIG[\"libdir\"] + \"/\" + Config::CONFIG[\"LIBRUBY\"]"')
  endtry
  if filereadable(s:ruby_libruby)
    let $RUBY_DLL = s:ruby_libruby
  endif
endif

"neocomplcacheの設定
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#auto_completion_start_length = 1
let g:neocomplete#min_keyword_length = 3
let g:neocomplete#min_syntax_length = 3
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_underbar_completion = 1
let g:neocomplete#snippets_dir = '$HOME/.vim/snippets'

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" <TAB>で補完
inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
" snippetsの展開
imap <expr><C-e> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-e>"
smap <expr><C-e> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-e>"

"VimShellの設定
noremap <silent> <C-x>s :VimShell<CR>
let g:vimshell_prompt = '> '

"ref.vimの設定
let g:ref_refe_cmd = "refe"
let g:ref_phpmanual_path = $HOME . "/.vim/manual/phpmanual"
let g:ref_phpmanual_cmd = "lynx -dump -nonumbers -display_charset=UTF-8 %s"

" for ref webdict
let g:ref_source_webdict_cmd = "lynx -dump -nonumbers -display_charset=UTF-8 %s"
let g:ref_source_webdict_encoding = "UTF-8"
let g:ref_source_webdict_sites = {
\   'wiktionary': {
\     'url': 'http://ja.wiktionary.org/wiki/%s',
\     'keyword_encoding': 'utf-8',
\     'cache': 1,
\   },
\   'wikipedia:ja': {
\     'url': 'http://ja.wikipedia.org/wiki/%s',
\     'keyword_encoding': 'utf-8',
\     'cache': 1,
\   },
\ }

au FileType perl setl kp=:Ref\ perldoc
au FileType php setl kp=:Ref\ phpmanual
au FileType python setl kp=:Ref\ pydoc
au FileType ruby setl kp=:Ref\ refe

"phpfolding.vimの設定
let g:DisableAutoPHPFolding = 1
au FileType php EnablePHPFolds

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
set nrformats=alpha,hex

"Git用
let git_diff_spawn_mode=1

let g:local_encoding = get(g:, 'local_encoding', '')
let g:local_termencoding = get(g:, 'local_termencoding', '')
"エンコーディング via kana/dot.vimrc
" To deal with Japanese language.
if $ENV_WORKING ==# 'summer'
  set encoding=japan
elseif has('win32')
  " vim-kaoriyaで内部エンコーディングがutf-8の場合
  if has('kaoriya') && glob($VIM."/switches/enabled/utf-8.vim") != ""
    set encoding=utf-8
  else
    set encoding=cp932
  endif
elseif g:local_encoding != ""
  let &encoding = g:local_encoding
else
  set encoding=utf-8
endif

if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  let s:enc_eucjpms_ready = 0
  let s:enc_eucjisx_ready = 0

  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_eucjpms_ready = 1
  endif

  " Does iconv support JIS X 0213 ?
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_eucjisx_ready = 1
  endif

  if s:enc_eucjpms_ready == 1 || s:enc_eucjisx_ready == 1
    if s:enc_eucjpms_ready == 1 && s:enc_eucjisx_ready == 1
      let s:enc_euc = 'eucjp-ms,euc-jisx0213,euc-jp'
    elseif s:enc_eucjpms_ready == 1
      let s:enc_euc = 'eucjp-ms,euc-jp'
    elseif s:enc_eucjisx_ready == 1
      let s:enc_euc = 'euc-jisx0213,euc-jp'
    endif
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
  elseif &encoding =~# '^euc\%(-jp\|-jisx0213\|jp-ms\)$'
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
elseif has('kaoriya') && ! has('gui') && glob($VIM."/switches/enabled/utf-8.vim") != ""
  set termencoding=cp932
  " g:vimshell_interactive_encodingsでutf-8を指定しなければ文字化けする
  if !exists('g:vimshell_interactive_encodings')
    let g:vimshell_interactive_encodings = {}
  endif
  let g:vimshell_interactive_encodings['/'] = 'utf-8'
elseif g:local_termencoding != ""
  let &termencoding = g:local_termencoding
else  " fallback
  set termencoding=  " same as 'encoding'
endif


" TabpageCD
" Reference: kana's vimrc
" XXX: move to config.toml

" eregex.vim
let g:eregex_default_enable = 0

"QuickRun用設定
let g:quickrun_config = {}
if has("clientserver") && v:servername != ''
  let g:quickrun_config["_"] = {'runner': 'remote', 'runner/remote/vimproc': 1}
else
  let g:quickrun_config["_"] = {'runner': 'vimproc','runner/vimproc/updatetime': 100}
endif
let g:quickrun_config.javascript = {'command': 'node'}
let g:quickrun_config.coffee =  {
\   'command': 'coffee',
\   'runner': 'vimproc',
\   'runner/vimproc/updatetime': 100
\ }
let g:quickrun_config['coffee/compile'] = {
\   'command': 'coffee',
\   'cmdopt': '-cp',
\   'runner': 'vimproc', 'runner/vimproc/updatetime': 100
\ }
let g:quickrun_config.less = {
\   'command': 'lessc',
\   'runner': 'vimproc',
\   'runner/vimproc/updatetime': 100
\ }
let g:quickrun_config.sass = {
\   'command': 'sass',
\   'cmdopt': '-t expanded',
\   'runner': 'vimproc', 'runner/vimproc/updatetime': 100
\ }

if has('win32')
  let g:quickrun_config.vb = {'command': 'cscript', 'cmdopt': '/Nologo', 'tempfile': "{tempname()}.vbs"}
endif

noremap <silent> <C-r> :QuickRun<CR>

"gundo用設定
if v:version < '703'
  noremap <silent> <C-u> :undolist<CR>
else
  nnoremap <silent> <C-u> :GundoToggle<CR>
endif

" unite用設定
noremap <silent> <C-B> :Unite -start-insert buffer<CR>
noremap <silent> <C-N> :UniteWithBufferDir -start-insert -buffer-name=files file<CR>
noremap <silent> <C-P> :Unite -start-insert file_mru<CR>
noremap <silent> <C-A> :UniteWithBufferDir -start-insert -buffer-name=files buffer file_mru bookmark file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

" neosnippet用設定
" Plugin settings.
let g:neosnippet#snippets_directory = $HOME."/.vim/snippets"

" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><Tab> pumvisible() ? "\<C-n>" : neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><Tab> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" for Tagbar
let g:tagbar_autofocus = 1
let g:tagbar_iconchars = ['+', '-']
noremap <silent> <C-T> :TagbarToggle<CR>

" for vimfiler
let g:vimfiler_as_default_explorer = 1
noremap <silent> <C-x>e :VimFilerExplorer<CR>

" for junkfile
let g:junkfile#directory = "~/.junkfiles"

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
noremap <silent> <Leader>n :cn<CR>
noremap <silent> <Leader>p :cp<CR>

" for neomru
let g:neomru#time_format = "[%Y/%m/%d %H:%M:%S] "

" for choosewin
nmap - <Plug>(choosewin)
let g:choosewin_overlay_enable = 1
let g:choosewin_overlay_clear_multibyte = 1
let g:choosewin_blink_on_land = 0
let g:choosewin_statusline_replace = 0
let g:choosewin_tabline_replace = 0

" for lightline
let g:lightline = {
      \   'colorscheme': 'jellybeans',
      \   'active': {
      \     'right': [
      \       ['lineinfo', 'syntastic'],
      \       ['percent'],
      \       ['git-branch', 'fileformat', 'fileencoding', 'filetype'],
      \     ]
      \   },
      \   'component_function': {
      \     'git-branch': 'GetBranchName',
      \   },
      \ }

function! GetBranchName()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? _ : ''
    endif
  catch
  endtry
  return ''
endfunction
