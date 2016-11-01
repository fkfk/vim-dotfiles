let s:dein_dir = g:myvimrc.rc.basedir . '/.vim/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let &rtp = &rtp .",". s:dein_repo_dir

let g:dein#install_progress_type = 'title'
let g:dein#install_log_filename = s:dein_dir . '/install.log'

let g:dein_toml_list = get(g:, 'dein_toml_list', [])
let g:dein_toml_list += [s:dein_dir . '/config.toml', s:dein_dir . '/config_local.toml']

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
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
