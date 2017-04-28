let mapleader = " "

" normal, visual, select, operator
noremap <silent> <C-h> gT
noremap <silent> <C-l> gt
noremap <silent> <C-r> :QuickRun<CR>
noremap <silent> <C-t> :TagbarToggle<CR>
noremap <silent> <C-w>N :vnew<CR>
noremap <silent> <C-x>s :VimShell<CR>
noremap <silent> <C-x>tn :tabnew<CR>
noremap <silent> <C-x>tq :tabclose<CR>
noremap <silent> <C-x>to :tabonly<CR>
noremap <silent> <ESC><ESC> :<C-u>call anzu#clear_search_status() \| exec 'nohl'<CR>
noremap <silent> <Leader>a :DeniteBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
noremap <silent> <Leader>b :Denite buffer<CR>
noremap <silent> <Leader>d :bdelete<CR>
noremap <silent> <Leader>D :bdelete!<CR>
noremap <silent> <Leader>h <C-w>H
noremap <silent> <Leader>j <C-w>J
noremap <silent> <Leader>k <C-w>K
noremap <silent> <Leader>l <C-w>L
noremap <silent> <Leader>n :DeniteBufferDir -buffer-name=files file<CR>
noremap <silent> <Leader>p :Denite file_mru<CR>
noremap <silent> <Leader>T <C-w>T
noremap <silent> <Leader>cn :cn<CR>
noremap <silent> <Leader>cp :cp<CR>
noremap <silent> <Leader>va :VCSAdd<CR>
noremap <silent> <Leader>vc :VCSCommit<CR>
noremap <silent> <Leader>vd :VCSDiff<CR>
noremap <silent> <Leader>vs :VCSStatus<CR>
noremap <silent> <M-a> <C-a>
noremap <silent> <M-c> :WatchdogsRun<CR>
noremap <silent> <M-r> <C-r>
noremap <silent> <M-t> <C-t>
noremap <silent> <M-x> <C-x>

" normal
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
nmap - <Plug>(choosewin)
nnoremap <silent> <C-u> :UndotreeToggle<CR>

" select
smap <expr> <C-e> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-e>"
smap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <expr> <Tab> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"

" input
imap <expr> <C-e> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-e>"
imap <C-k> <Plug>(neosnippet_expand_or_jump)
imap <expr> <Tab> pumvisible() ? "\<C-n>" : neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
inoremap <expr> <tab> pumvisible() ? "\<C-n>" : "\<TAB>"

" visual
vnoremap g<M-a> g<C-a>
vnoremap g<M-x> g<C-x>
