if !exists("s:original_ruby_libruby")
  let s:original_ruby_libruby = &rubydll
endif

if exists('&rubydll') && !has('ruby')
  let l:dllpath = g:myvimrc.find_rubydll()
  if s:dllpath != ""
    let &rubydll = l:dllpath
  endif
endif
