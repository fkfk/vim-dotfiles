"neocomplcacheの設定
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#auto_completion_start_length = 1
let g:neocomplete#min_keyword_length = 3
let g:neocomplete#min_syntax_length = 3
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_underbar_completion = 1
let g:neocomplete#snippets_dir = g:myvimrc.rc.basedir . '/.vim/snippets'

let g:neocomplete#keyword_patterns = get(g:, 'neocomplete#keyword_patterns', {})
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

"VimShellの設定
let g:vimshell_prompt = '> '

"ref.vimの設定
let g:ref_refe_cmd = "refe"
let g:ref_phpmanual_path = g:myvimrc.rc.basedir . "/.vim/manual/phpmanual"
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

"phpfolding.vimの設定
let g:DisableAutoPHPFolding = 1

"Git用
let git_diff_spawn_mode=1

" eregex.vim
let g:eregex_default_enable = 0

"QuickRun用設定
let g:quickrun_config = {
\   '_': {
\     'runner': 'vimproc',
\     'runner/vimproc/updatetime': 100
\   },
\   'coffee': {
\     'command': 'coffee',
\     'runner': 'vimproc',
\     'runner/vimproc/updatetime': 100
\   },
\   'coffee/compile': {
\     'command': 'coffee',
\     'cmdopt': '-cp',
\     'runner': 'vimproc',
\     'runner/vimproc/updatetime': 100
\   },
\   'javascript': {
\     'command': 'node'
\   },
\   'less': {
\     'command': 'lessc',
\     'runner': 'vimproc',
\     'runner/vimproc/updatetime': 100
\   },
\   'sass': {
\     'command': 'sass',
\     'cmdopt': '-t expanded',
\     'runner': 'vimproc',
\     'runner/vimproc/updatetime': 100
\   },
\   'vb': {
\     'command': 'cscript',
\     'cmdopt': '/Nologo',
\     'tempfile': "{tempname()}.vbs"
\   }
\ }
if has("clientserver") && v:servername != ''
  let g:quickrun_config["_"] = {'runner': 'remote', 'runner/remote/vimproc': 1}
endif

" neosnippet用設定
" Plugin settings.
let g:neosnippet#snippets_directory = g:myvimrc.rc.basedir."/.vim/snippets"

" for Tagbar
let g:tagbar_autofocus = 1
let g:tagbar_iconchars = ['+', '-']

" for vimfiler
let g:vimfiler_as_default_explorer = 1

" for junkfile
let g:junkfile#directory = "~/.junkfiles"

" for neomru
let g:neomru#time_format = "[%Y/%m/%d %H:%M:%S] "

" for choosewin
let g:choosewin_overlay_enable = 1
let g:choosewin_overlay_clear_multibyte = 1
let g:choosewin_blink_on_land = 0
let g:choosewin_statusline_replace = 0
let g:choosewin_tabline_replace = 0

" for vim-gocode
let g:gocomplete#system_function = 'vimproc#system'

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

" Windowsでscpを使う場合pscp.exeを用いる
if has('win32') && executable('pscp.exe')
  let g:netrw_scp_cmd = "pscp.exe -q"
  let g:unite_kind_file_ssh_command = 'plink.exe -P PORT HOSTNAME'
  let g:unite_kind_file_ssh_copy_directory_command = 'pscp.exe -P PORT -q -r $srcs $dest'
  let g:unite_kind_file_ssh_copy_file_command = 'pscp.exe -P PORT -q $srcs $dest'
  let g:neossh#ssh_command = 'plink.exe -P PORT HOSTNAME'
  let g:neossh#copy_directory_command = 'pscp.exe -P PORT -q -r $srcs $dest'
  let g:neossh#copy_file_command = 'pscp.exe -P PORT -q $srcs $dest'
endif
