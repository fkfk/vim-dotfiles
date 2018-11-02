if !has('nvim') && !exists("s:original_ruby_libruby")
  let s:original_ruby_libruby = &rubydll
endif

if !has('nvim') && exists('&rubydll') && !has('ruby')
  let s:dllpath = g:myvimrc.find_rubydll()
  if s:dllpath != ""
    let &rubydll = s:dllpath
  endif
endif
