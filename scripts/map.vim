let mapleader = " "

" normal, visual, select, operator
noremap <silent> <C-a> :UniteWithBufferDir -start-insert -buffer-name=files buffer file_mru bookmark file<CR>
noremap <silent> <C-b> :Unite -start-insert buffer<CR>
noremap <silent> <C-h> gT
noremap <silent> <C-l> gt
noremap <silent> <C-n> :UniteWithBufferDir -start-insert -buffer-name=files file<CR>
noremap <silent> <C-p> :Unite -start-insert file_mru<CR>
noremap <silent> <C-r> :QuickRun<CR>
noremap <silent> <C-t> :TagbarToggle<CR>
noremap <silent> <C-w>N :vnew<CR>
noremap <silent> <C-x>c :WatchdogsRun<CR>
noremap <silent> <C-x>e :VimFilerExplorer<CR>
noremap <silent> <C-x>s :VimShell<CR>
noremap <silent> <C-x>r :source $HOME/.vimrc<CR>
noremap <silent> <C-x>tn :tabnew<CR>
noremap <silent> <C-x>tq :tabclose<CR>
noremap <silent> <C-x>to :tabonly<CR>
noremap <silent> <ESC><ESC> :<C-u>call anzu#clear_search_status() \| exec 'nohl'<CR>
noremap <silent> <Leader>d :bdelete<CR>
noremap <silent> <Leader>D :bdelete!<CR>
noremap <silent> <Leader>h <C-w>H
noremap <silent> <Leader>j <C-w>J
noremap <silent> <Leader>k <C-w>K
noremap <silent> <Leader>l <C-w>L
noremap <silent> <Leader>n :cn<CR>
noremap <silent> <Leader>p :cp<CR>
noremap <silent> <Leader>T <C-w>T
noremap <silent> <Leader>va :VCSAdd<CR>
noremap <silent> <Leader>vc :VCSCommit<CR>
noremap <silent> <Leader>vd :VCSDiff<CR>
noremap <silent> <Leader>vs :VCSStatus<CR>

" normal
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
nmap - <Plug>(choosewin)
nnoremap <silent> <C-u> :GundoToggle<CR>

" select
smap <expr> <C-e> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-e>"
smap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <expr> <Tab> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"

" input
imap <expr> <C-e> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-e>"
imap <C-k> <Plug>(neosnippet_expand_or_jump)
imap <expr> <Tab> pumvisible() ? "\<C-n>" : neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
inoremap <expr> <tab> pumvisible() ? "\<C-n>" : "\<TAB>"
