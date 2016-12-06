" eregex.vim
let g:eregex_default_enable = 0

" for junkfile
let g:junkfile#directory = "~/.junkfiles"

" for lightline
let g:lightline = {
      \   'colorscheme': 'jellybeans',
      \   'active': {
      \     'left': [
      \         ['mode', 'paste'],
      \         ['readonly', 'filename', 'modified', 'anzu']
      \     ],
      \     'right': [
      \       ['lineinfo', 'syntastic'],
      \       ['percent'],
      \       ['git-branch', 'fileformat', 'fileencoding', 'filetype'],
      \     ]
      \   },
      \   'component_function': {
      \     'filename': 'g:myvimrc.get_printable_filename',
      \     'git-branch': 'g:myvimrc.get_current_branch_name',
      \     'anzu': 'anzu#search_status'
      \   },
      \ }

" for neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#auto_completion_start_length = 1
let g:neocomplete#min_keyword_length = 3
let g:neocomplete#min_syntax_length = 3
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_underbar_completion = 1
let g:neocomplete#snippets_dir = g:myvimrc.rc.basedir . '/snippets'
let g:neocomplete#keyword_patterns = get(g:, 'neocomplete#keyword_patterns', {})
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" for neomru
let g:neomru#time_format = "[%Y/%m/%d %H:%M:%S] "

" for neosnippet
let g:neosnippet#snippets_directory = g:myvimrc.rc.basedir."/snippets"

" for phpfolding.vim
let g:DisableAutoPHPFolding = 1

" for Tagbar
let g:tagbar_autofocus = 1
let g:tagbar_iconchars = ['+', '-']

" for choosewin
let g:choosewin_overlay_enable = 1
let g:choosewin_overlay_clear_multibyte = 1
let g:choosewin_blink_on_land = 0
let g:choosewin_statusline_replace = 0
let g:choosewin_tabline_replace = 0

" for quickrun
let g:quickrun_config = {
\   '_': {
\     'runner': 'vimproc',
\     'runner/vimproc/updatetime': 100
\   },
\   'coffee': {
\     'command': 'coffee'
\   },
\   'coffee/compile': {
\     'command': 'coffee',
\     'cmdopt': '-cp'
\   },
\   'javascript': {
\     'command': 'node'
\   },
\   'less': {
\     'command': 'lessc'
\   },
\   'sass': {
\     'command': 'sass',
\     'cmdopt': '-t expanded'
\   },
\   'vb': {
\     'command': 'cscript',
\     'cmdopt': '/Nologo',
\     'tempfile': "{tempname()}.vbs"
\   },
\   'php/watchdogs_checker': {
\       'type': 'watchdogs_checker/php'
\   },
\   'watchdogs_checker/_': {
\     'runner/vimproc/updatetime':       40,
\     'hook/close_quickfix/enable_exit': 0,
\     'hook/back_window/enable':         1,
\     'hook/back_window/enable_exit':    1,
\     'hook/back_window/priority_exit':  1,
\   },
\   'watchdogs_checker/php': {
\       'command': 'php',
\       'cmdopt':  '-l -d error_reporting=E_ALL -d display_errors=1 -d display_startup_errors=1 -d log_errors=0 -d xdebug.cli_color=0',
\       'exec':    '%c %o %s:p'
\   },
\ }
if has("clientserver") && v:servername != ''
  let g:quickrun_config["_"] = {'runner': 'remote', 'runner/remote/vimproc': 1}
endif

" for vim-ref
let g:ref_refe_cmd = "refe"
let g:ref_phpmanual_path = g:myvimrc.rc.basedir . "/manual/phpmanual"
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

" for vcscommand
let git_diff_spawn_mode=1

" for vimfiler
let g:vimfiler_as_default_explorer = 1

" for vimshell
let g:vimshell_prompt = '> '

" for watchdogs
let g:watchdogs_check_BufWritePost_enable = 1
let g:watchdogs_check_CursorHold_enable = 1

" Windowsでscpを使う場合pscp.exeを用いる
if has('win32') && executable('pscp.exe')
  " for netrw
  let g:netrw_scp_cmd = "pscp.exe -q"

  " for unite-ssh
  let g:unite_kind_file_ssh_command = 'plink.exe -P PORT HOSTNAME'
  let g:unite_kind_file_ssh_copy_directory_command = 'pscp.exe -P PORT -q -r $srcs $dest'
  let g:unite_kind_file_ssh_copy_file_command = 'pscp.exe -P PORT -q $srcs $dest'
  let g:neossh#ssh_command = 'plink.exe -P PORT HOSTNAME'
  let g:neossh#copy_directory_command = 'pscp.exe -P PORT -q -r $srcs $dest'
  let g:neossh#copy_file_command = 'pscp.exe -P PORT -q $srcs $dest'
endif

function! g:myvimrc.rc.lazyconfig.altercmd()
  call altercmd#load()

  AlterCommand g Global
  AlterCommand v Vglobal
  AlterCommand s Substitute
  AlterCommand %g %Global
  AlterCommand %v %Vglobal
  AlterCommand %s %Substitute
  AlterCommand '<,'>g '<,'>Global
  AlterCommand '<,'>v '<,'>Vglobal
  AlterCommand '<,'>s '<,'>Substitute

  command! -nargs=? Exec call vimproc#system(<q-args>)
  AlterCommand ! Exec

  call g:myvimrc.rc.lazyconfig.enable_tabpagecd()
endfunction

function! g:myvimrc.rc.lazyconfig.enable_tabpagecd()
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
endfunction

function! g:myvimrc.rc.lazyconfig.smartinput()
  call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
  call smartinput#map_to_trigger('i', '#', '#', '#')
  call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')

  call smartinput#define_rule({
  \   'at'    : '(\%#)',
  \   'char'  : '<Space>',
  \   'input' : '<Space><Space><Left>',
  \   })

  call smartinput#define_rule({
  \   'at'    : '( \%# )',
  \   'char'  : '<BS>',
  \   'input' : '<Del><BS>',
  \   })

  call smartinput#define_rule({
  \   'at': '\s\+\%#',
  \   'char': '<CR>',
  \   'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR>",
  \   })

  call smartinput#define_rule({
  \   'at' : '\({\|\<do\>\)\s*\%#',
  \   'char' : '<Bar>',
  \   'input' : '<Bar><Bar><Left>',
  \   'filetype' : ['ruby'],
  \    })
endfunction

function! g:myvimrc.rc.lazyconfig.watchdogs()
  call watchdogs#setup(g:quickrun_config)
endfunction