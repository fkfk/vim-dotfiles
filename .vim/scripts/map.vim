let mapleader = " "

" <TAB>で補完
inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
" snippetsの展開
imap <expr><C-e> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-e>"
smap <expr><C-e> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-e>"

noremap <silent> <C-x>s :VimShell<CR>

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

" VCSCommand
noremap <silent> <Leader>vd :VCSDiff<CR>
noremap <silent> <Leader>va :VCSAdd<CR>
noremap <silent> <Leader>vc :VCSCommit<CR>
noremap <silent> <Leader>vs :VCSStatus<CR>

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

" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><Tab> pumvisible() ? "\<C-n>" : neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><Tab> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"

noremap <silent> <C-T> :TagbarToggle<CR>

noremap <silent> <C-x>e :VimFilerExplorer<CR>

noremap <silent> <Leader>n :cn<CR>
noremap <silent> <Leader>p :cp<CR>

nmap - <Plug>(choosewin)

" for vim-anzu
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
noremap <silent> <ESC><ESC> :<C-u>call anzu#clear_search_status() \| exec 'nohl'<CR>
