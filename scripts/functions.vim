function! g:myvimrc.get_current_branch_name()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? _ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! g:myvimrc.get_printable_filename()
  let nr = bufnr('%')
  if expand('%:t') != ''
    let name = expand('%:t')
  else
    let name = '[No Name]'
  endif
  return nr .":" . name
endfunction

function! g:myvimrc.system(cmd)
  let l:ret = ""
  if exists("*vimproc#system")
    let l:ret = vimproc#system(a:cmd)
  else
    let l:ret = system(a:cmd)
  endif
  return l:ret
endfunction

function! g:myvimrc.find_rubydll()
  let l:dllpath = g:myvimrc.system('ruby -rrbconfig -e "print File.join RbConfig::CONFIG[%|bindir|], RbConfig::CONFIG[%|LIBRUBY_SO|]"')
  if filereadable(l:dllpath)
    return l:dllpath
  else
    return ""
  endif
endfunction
