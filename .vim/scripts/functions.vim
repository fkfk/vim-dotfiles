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
  if &ft == 'vimfiler'
    let name = vimfiler#get_status_string()
  elseif &ft == 'unite'
    let name = unite#get_status_string()
  elseif expand('%:t') != ''
    let name = expand('%:t')
  else
    let name = '[No Name]'
  endif
  return nr .":" . name
endfunction
