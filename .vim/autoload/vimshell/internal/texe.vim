"=============================================================================
" FILE: texe.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 25 Jun 2010
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:update_time_save = &updatetime

function! vimshell#internal#texe#execute(command, args, fd, other_info)"{{{
  " Interactive execute command.
  let [l:args, l:options] = vimshell#parser#getopt(a:args, 
        \{ 'arg=' : ['--encoding']
        \})
  if empty(l:args)
    return
  endif

  if vimshell#iswin()
    " Use Cygwin pty.
    call insert(l:args, 'fakecygpty')

    if !executable('fakecygpty')
      call vimshell#error_line(a:fd, 'texe: "fakecygpty.exe" is required. Please install it.')
      return
    endif

    if len(l:args) < 2
      call vimshell#error_line(a:fd, 'texe: command is required.')
      return
    endif

    " Get program path from g:vimshell_interactive_cygwin_path.
    let l:args[1] = vimproc#get_command_name(l:args[1], g:vimshell_interactive_cygwin_path)
  endif

  let l:cmdname = fnamemodify(l:args[0], ':r')
  if !has_key(l:options, '--encoding')
    let l:options['--encoding'] = has_key(g:vimshell_interactive_encodings, l:cmdname) ?
          \ g:vimshell_interactive_encodings[l:cmdname] : &termencoding
  endif

  " Encoding conversion.
  if l:options['--encoding'] != '' && l:options['--encoding'] != &encoding
    call map(l:args, 'iconv(v:val, &encoding, l:options["--encoding"])')
  endif

  if exists('b:interactive') && b:interactive.process.is_valid
    " Delete zombee process.
    call vimshell#interactive#force_exit()
  endif

  " Initialize.
  if vimshell#iswin()
    if g:vimshell_interactive_cygwin_home != ''
      " Set $HOME.
      let l:home_save = $HOME
      let $HOME = g:vimshell_interactive_cygwin_home
    endif
  endif

  let l:sub = vimproc#ptyopen(l:args)

  if vimshell#iswin()
    if g:vimshell_interactive_cygwin_home != ''
      " Restore $HOME.
      let $HOME = l:home_save
    endif
  endif

  call s:init_bg(l:sub, l:args, a:fd, a:other_info)

  " Set variables.
  let b:interactive = {
        \ 'process' : l:sub, 
        \ 'fd' : a:fd, 
        \ 'encoding' : l:options['--encoding'],
        \ 'is_secret': 0, 
        \ 'prompt_history' : {}, 
        \ 'command_history' : [], 
        \ 'is_pty' : 1,
        \ 'is_background': 0, 
        \ 'args' : l:args,
        \ 'echoback_linenr' : 0,
        \ 'save_cursor' : getpos('.'),
        \}

  startinsert!

  wincmd p
endfunction"}}}

function! vimshell#internal#texe#vimshell_texe(args)"{{{
  call vimshell#internal#texe#execute('texe', vimshell#parser#split_args(a:args), {'stdin' : '', 'stdout' : '', 'stderr' : ''}, {'is_interactive' : 0})
endfunction"}}}

function! vimshell#internal#texe#default_settings()"{{{
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nowrap
  setlocal tabstop=8
  setfiletype vimshell-term

  " Define mappings.
  call vimshell#term_mappings#define_default_mappings()
endfunction"}}}

function! s:init_bg(sub, args, fd, other_info)"{{{
  " Save current directiory.
  let l:cwd = getcwd()

  " Split nicely.
  call vimshell#split_nicely()

  edit `=fnamemodify(a:args[0], ':r').'$'.(bufnr('$')+1)`
  lcd `=l:cwd`

  call vimshell#internal#texe#default_settings()
  
  " Set autocommands.
  augroup vimshell_iexe
    autocmd InsertEnter <buffer>       call s:insert_enter()
    autocmd InsertLeave <buffer>       call s:insert_leave()
    autocmd BufUnload <buffer>       call vimshell#interactive#hang_up(expand('<afile>'))
    autocmd CursorHoldI <buffer>  call s:on_hold_i()
  augroup END
endfunction"}}}

function! s:insert_enter()"{{{
  if &updatetime > g:vimshell_interactive_update_time
    let s:update_time_save = &updatetime
    let &updatetime = g:vimshell_interactive_update_time
  endif

  if exists(':NeoComplCacheDisable')
    " Lock neocomplcache.
    NeoComplCacheLock
  endif

  call setpos('.', b:interactive.save_cursor)
  if b:interactive.save_cursor[2] > len(getline(b:interactive.save_cursor[1]))
    startinsert!
  endif
endfunction"}}}
function! s:insert_leave()"{{{
  if &updatetime < s:update_time_save
    let &updatetime = s:update_time_save
  endif
endfunction"}}}
function! s:on_hold_i()"{{{
  if line('.') == line('$')
    call vimshell#interactive#check_output(b:interactive, bufnr('%'), bufnr('%'))
    if b:interactive.process.is_valid
      " Ignore key sequences.
      call feedkeys("\<C-r>\<ESC>", 'n')
    endif
  endif
endfunction"}}}
function! s:on_moved_i()"{{{
  call vimshell#interactive#check_output(b:interactive, bufnr('%'), bufnr('%'))
endfunction"}}}

