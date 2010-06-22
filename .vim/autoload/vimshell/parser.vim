"=============================================================================
" FILE: parser.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 18 Jun 2010
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

function! vimshell#parser#check_script(script)"{{{
  " Parse check only.
  " Split statements.
  for l:statement in vimshell#parser#split_statements(a:script)
    let l:args = vimshell#parser#split_args(l:statement)
  endfor

  return 0
endfunction"}}}
function! vimshell#parser#eval_script(script, context)"{{{
  " Split statements.
  for l:statement in vimshell#parser#split_statements(a:script)
    let l:statement = vimshell#parser#parse_alias(l:statement)
    
    " Call preexec filter.
    let l:statement = vimshell#hook#call_filter('preexec', a:context, l:statement)

    let [l:program, l:script] = vimshell#parser#parse_program(l:statement)

    if has_key(g:vimshell#special_func_table, l:program)
      " Special commands.
      let l:fd = { 'stdin' : '', 'stdout' : '', 'stderr' : '' }
      let l:args = split(l:script)
    else
      " Expand block.
      if l:script =~ '{'
        let l:script = s:parse_block(l:script)
      endif

      " Expand tilde.
      if l:script =~ '\~'
        let l:script = s:parse_tilde(l:script)
      endif

      " Expand filename.
      if l:script =~ ' ='
        let l:script = s:parse_equal(l:script)
      endif

      " Expand variables.
      if l:script =~ '\$'
        let l:script = s:parse_variables(l:script)
      endif

      " Expand wildcard.
      if l:script =~ '[[*?]\|\\[()|]'
        let l:script = s:parse_wildcard(l:script)
      endif

      " Parse redirection.
      if l:script =~ '[<>]'
        let [l:fd, l:script] = s:parse_redirection(l:script)
      else
        let l:fd = { 'stdin' : '', 'stdout' : '', 'stderr' : '' }
      endif

      " Split args.
      let l:args = vimshell#parser#split_args(l:script)
    endif

    if l:fd.stdout != ''
      if l:fd.stdout =~ '^>'
        let l:fd.stdout = l:fd.stdout[1:]
      elseif l:fd.stdout == '/dev/null'
        " Nothing.
      elseif l:fd.stdout == '/dev/clip'
        " Clear.
        let @+ = ''
      else
        " Create file.
        call writefile([], l:fd.stdout)
      endif
    endif

    call vimshell#parser#execute_command(l:program, l:args, l:fd, a:context)
    redraw
  endfor
endfunction"}}}
function! vimshell#parser#parse_alias(statement)"{{{
  " Get program.
  let l:program = matchstr(s:parse_galias(a:statement), vimshell#get_program_pattern())
  if l:program  == ''
    throw 'Error: Invalid command name.'
  endif
  let l:script = a:statement[len(l:program) :]

  if exists('b:vimshell') && has_key(b:vimshell.alias_table, l:program) && !empty(b:vimshell.alias_table[l:program])
    " Expand alias.
    let l:program = s:recursive_expand_alias(l:program)
  endif
  
  return l:program . l:script
endfunction"}}}
function! vimshell#parser#parse_program(statement)"{{{
  " Get program.
  let l:program = matchstr(a:statement, vimshell#get_program_pattern())
  if l:program  == ''
    throw 'Error: Invalid command name.'
  endif
  let l:script = a:statement[len(l:program) :]

  if l:program != '' && l:program[0] == '~'
    " Parse tilde.
    let l:program = substitute($HOME, '\\', '/', 'g') . l:program[1:]
  endif
  
  return [l:program, l:script]
endfunction"}}}

function! vimshell#parser#execute_command(program, args, fd, other_info)"{{{
  if empty(a:args)
    let l:line = a:program
  else
    let l:line = printf('%s %s', a:program, join(a:args, ' '))
  endif
  let l:program = a:program
  let l:dir = substitute(substitute(l:line, '^\~\ze[/\\]', substitute($HOME, '\\', '/', 'g'), ''), '\\\(.\)', '\1', 'g')
  let l:command = vimshell#getfilename(program)

  " Special commands.
  if l:line =~ '&\s*$'"{{{
    " Background execution.
    return vimshell#execute_internal_command('bg', split(substitute(l:line, '&\s*$', '', '')), a:fd, a:other_info)
    "}}}
  elseif has_key(g:vimshell#special_func_table, l:program)"{{{
    " Other special commands.
    return call(g:vimshell#special_func_table[l:program], [l:program, a:args, a:fd, a:other_info])
    "}}}
  elseif has_key(g:vimshell#internal_func_table, l:program)"{{{
    " Internal commands.
    return call(g:vimshell#internal_func_table[l:program], [l:program, a:args, a:fd, a:other_info])
    "}}}
  elseif isdirectory(l:dir)"{{{
    " Directory.
    " Change the working directory like zsh.

    " Call internal cd command.
    return vimshell#execute_internal_command('cd', [l:dir], a:fd, a:other_info)
    "}}}
  elseif l:command != '' || executable(l:program)"{{{
    " Execute external commands.

    " Suffix execution.
    let l:ext = fnamemodify(l:program, ':e')
    if !empty(l:ext) && has_key(g:vimshell_execute_file_list, l:ext)
      " Execute file.
      let l:execute = split(g:vimshell_execute_file_list[l:ext])[0]
      let l:args = extend(split(g:vimshell_execute_file_list[l:ext])[1:], insert(a:args, l:program))
      return vimshell#parser#execute_command(l:execute, l:args, a:fd, a:other_info)
    else
      return vimshell#execute_internal_command('exe', insert(a:args, l:program), a:fd, a:other_info)
    endif
  else
    throw printf('Error: File "%s" is not found.', l:program)
  endif
  "}}}
endfunction
"}}}

function! vimshell#parser#split_statements(script)"{{{
  let l:max = len(a:script)
  let l:statements = []
  let l:statement = ''
  let i = 0
  while i < l:max
    if a:script[i] == ';'
      if l:statement != ''
        call add(l:statements, l:statement)
      endif
      let l:statement = ''
      let i += 1
    elseif a:script[i] == "'"
      " Single quote.
      let [l:string, i] = s:skip_single_quote(a:script, i)
      let l:statement .= l:string
    elseif a:script[i] == '"'
      " Double quote.
      let [l:string, i] = s:skip_double_quote(a:script, i)
      let l:statement .= l:string
    elseif a:script[i] == '`'
      " Back quote.
      let [l:string, i] = s:skip_back_quote(a:script, i)
      let l:statement .= l:string
    elseif a:script[i] == '\'
      " Escape.
      let i += 1

      if i >= len(a:script)
        throw 'Exception: Join to next line (\).'
      endif

      let l:statement .= '\' . a:script[i]
      let i += 1
    elseif a:script[i] == '#'
      " Comment.
      break
    else
      let l:statement .= a:script[i]
      let i += 1
    endif
  endwhile

  if l:statement != ''
    call add(l:statements, l:statement)
  endif

  return l:statements
endfunction"}}}
function! vimshell#parser#split_args(script)"{{{
  let l:script = a:script
  let l:max = len(l:script)
  let l:args = []
  let l:arg = ''
  let i = 0
  while i < l:max
    if l:script[i] == "'"
      " Single quote.
      let [l:arg_quote, i] = s:parse_single_quote(l:script, i)
      let l:arg .= l:arg_quote
      if l:arg == ''
        call add(l:args, '')
      endif
    elseif l:script[i] == '"'
      " Double quote.
      let [l:arg_quote, i] = s:parse_double_quote(l:script, i)
      let l:arg .= l:arg_quote
      if l:arg == ''
        call add(l:args, '')
      endif
    elseif l:script[i] == '`'
      " Back quote.
      let [l:arg_quote, i] = s:parse_back_quote(l:script, i)
      let l:arg .= l:arg_quote
      if l:arg == ''
        call add(l:args, '')
      endif
    elseif l:script[i] == '\'
      " Escape.
      let i += 1

      if i > l:max
        throw 'Exception: Join to next line (\).'
      endif

      let l:arg .= l:script[i]
      let i += 1
    elseif l:script[i] == '#'
      " Comment.
      break
    elseif l:script[i] != ' '
      let l:arg .= l:script[i]
      let i += 1
    else
      " Space.
      if l:arg != ''
        call add(l:args, l:arg)
      endif

      let l:arg = ''

      let i += 1
    endif
  endwhile

  if l:arg != ''
    call add(l:args, l:arg)
  endif

  " Substitute modifier.
  let l:ret = []
  for l:arg in l:args
    if l:arg =~ '\%(:[p8~.htre]\)\+$'
      let l:modify = matchstr(l:arg, '\%(:[p8~.htre]\)\+$')
      let l:arg = fnamemodify(l:arg[: -len(l:modify)-1], l:modify)
    endif

    call add(l:ret, l:arg)
  endfor

  return l:ret
endfunction"}}}
function! vimshell#parser#split_args_through(script)"{{{
  let l:script = a:script
  let l:max = len(l:script)
  let l:args = []
  let l:arg = ''
  let i = 0
  while i < l:max
    if l:script[i] == "'"
      " Single quote.
      let [l:string, i] = s:skip_single_quote(l:script, i)
      let l:arg .= l:string
      if l:arg == ''
        call add(l:args, '')
      endif
    elseif l:script[i] == '"'
      " Double quote.
      let [l:string, i] = s:skip_double_quote(l:script, i)
      let l:arg .= l:string
      if l:arg == ''
        call add(l:args, '')
      endif
    elseif l:script[i] == '`'
      " Back quote.
      let [l:string, i] = s:skip_back_quote(l:script, i)
      let l:arg .= l:string
      if l:arg == ''
        call add(l:args, '')
      endif
    elseif l:script[i] == '\'
      " Escape.
      let i += 1

      if i > l:max
        throw 'Exception: Join to next line (\).'
      endif

      let l:arg .= '\'.l:script[i]
      let i += 1
    elseif l:script[i] != ' '
      let l:arg .= l:script[i]
      let i += 1
    else
      " Space.
      if l:arg != ''
        call add(l:args, l:arg)
      endif

      let l:arg = ''

      let i += 1
    endif
  endwhile

  if l:arg != ''
    call add(l:args, l:arg)
  endif

  return l:args
endfunction"}}}
function! vimshell#parser#split_pipe(script)"{{{
  let l:script = ''

  let i = 0
  let l:max = len(a:script)
  let l:commands = []
  while i < l:max
    if a:script[i] == '|'
      " Pipe.
      call add(l:commands, l:script)

      " Search next command.
      let l:script = ''
      let i += 1
    elseif a:script[i] == "'"
      " Single quote.
      let [l:string, i] = s:skip_quote(a:script, i)
      let l:script .= l:string
    elseif a:script[i] == '"'
      " Double quote.
      let [l:string, i] = s:skip_double_quote(a:script, i)
      let l:script .= l:string
    elseif a:script[i] == '`'
      " Back quote.
      let [l:string, i] = s:skip_back_quote(a:script, i)
      let l:script .= l:string
    elseif a:script[i] == '\' && i + 1 < l:max
      " Escape.
      let l:script .= '\' . a:script[i+1]
      let i += 2
    else
      let l:script .= a:script[i]
      let i += 1
    endif
  endwhile

  call add(l:commands, l:script)

  return l:commands
endfunction"}}}
function! vimshell#parser#split_commands(script)"{{{
  let l:script = a:script
  let l:max = len(l:script)
  let l:commands = []
  let l:command = ''
  let i = 0
  while i < l:max
    if l:script[i] == '\'
      " Escape.
      let l:command .= l:script[i]
      let i += 1

      if i > l:max
        throw 'Exception: Join to next line (\).'
      endif

      let l:command .= l:script[i]
      let i += 1
    elseif l:script[i] == '|'
      if l:command != ''
        call add(l:commands, l:command)
      endif
      let l:command = ''

      let i += 1
    else

      let l:command .= l:script[i]
      let i += 1
    endif
  endwhile

  if l:command != ''
    call add(l:commands, l:command)
  endif

  return l:commands
endfunction"}}}
function! vimshell#parser#check_wildcard()"{{{
  let l:args = vimshell#get_current_args()
  return !empty(l:args) && l:args[-1] =~ '[[*?]\|^\\[()|]'
endfunction"}}}
function! vimshell#parser#expand_wildcard(wildcard)"{{{
  " Exclude wildcard.
  let l:wildcard = a:wildcard
  let l:exclude = matchstr(l:wildcard, '\~.*$')
  if l:exclude != ''
    " Trunk l:wildcard.
    let l:wildcard = l:wildcard[: len(l:wildcard)-len(l:exclude)-1]
  endif

  " Expand wildcard.
  let l:expanded = split(escape(substitute(glob(l:wildcard), '\\', '/', 'g'), ' '), '\n')
  let l:exclude_wilde = split(escape(substitute(glob(l:exclude[1:]), '\\', '/', 'g'), ' '), '\n')
  if !empty(l:exclude_wilde)
    let l:candidates = l:expanded
    let l:expanded = []
    for candidate in l:candidates
      let l:found = 0

      for ex in l:exclude_wilde
        if candidate == ex
          let l:found = 1
          break
        endif
      endfor

      if l:found == 0
        call add(l:expanded, candidate)
      endif
    endfor
  endif

  return filter(l:expanded, 'v:val != "." && v:val != ".."')
endfunction"}}}
function! vimshell#parser#getopt(args, optsyntax)"{{{
  " Initialize.
  let l:optsyntax = a:optsyntax
  if !has_key(l:optsyntax, 'noarg')
    let l:optsyntax['noarg'] = []
  endif
  if !has_key(l:optsyntax, 'noarg_short')
    let l:optsyntax['noarg_short'] = []
  endif
  if !has_key(l:optsyntax, 'arg1')
    let l:optsyntax['arg1'] = []
  endif
  if !has_key(l:optsyntax, 'arg1_short')
    let l:optsyntax['arg1_short'] = []
  endif
  if !has_key(l:optsyntax, 'arg=')
    let l:optsyntax['arg='] = []
  endif

  let l:args = []
  let l:options = {}
  for l:arg in a:args
    let l:found = 0

    for l:opt in l:optsyntax['arg=']
      if vimshell#head_match(l:arg, l:opt.'=')
        let l:found = 1

        " Get argument value.
        let l:options[l:opt] = l:arg[len(l:opt.'='):]

        break
      endif
    endfor
    if l:found
      " Next argument.
      continue
    endif

    if !l:found
      call add(l:args, l:arg)
    endif
  endfor

  return [l:args, l:options]
endfunction"}}}

" Parse helper.
function! s:parse_galias(script)"{{{
  if !exists('b:vimshell')
    return a:script
  endif
  
  let l:script = a:script
  let l:max = len(l:script)
  let l:args = []
  let l:arg = ''
  let i = 0
  while i < l:max
    if l:script[i] == '\'
      " Escape.
      let i += 1

      if i > l:max
        throw 'Exception: Join to next line (\).'
      endif

      let l:arg .= l:script[i]
      let i += 1
    elseif l:script[i] != ' '
      let l:arg .= l:script[i]
      let i += 1
    else
      " Space.
      if l:arg != ''
        call add(l:args, l:arg)
      endif

      let l:arg = ''

      let i += 1
    endif
  endwhile

  if l:arg != ''
    call add(l:args, l:arg)
  endif

  " Expand global alias.
  let i = 0
  for l:arg in l:args
    if has_key(b:vimshell.galias_table, l:arg)
      let l:args[i] = b:vimshell.galias_table[l:arg]
    endif

    let i += 1
  endfor

  return join(l:args)
endfunction"}}}
function! s:parse_block(script)"{{{
  let l:script = ''

  let i = 0
  let l:max = len(a:script)
  while i < l:max
    if a:script[i] == '{'
      " Block.
      let l:head = matchstr(a:script[: i-1], '[^[:blank:]]*$')
      " Trunk l:script.
      let l:script = l:script[: -len(l:head)-1]
      let l:block = matchstr(a:script, '{\zs.*[^\\]\ze}', i)
      if l:block == ''
        throw 'Exception: Block is not found.'
      elseif l:block =~ '^\d\+\.\.\d\+$'
        " Range block.
        let l:start = matchstr(l:block, '^\d\+')
        let l:end = matchstr(l:block, '\d\+$')
        let l:zero = len(matchstr(l:block, '^0\+'))
        let l:pattern = '%0' . l:zero . 'd'
        for l:b in range(l:start, l:end)
          " Concat.
          let l:script .= l:head . printf(l:pattern, l:b) . ' '
        endfor
      else
        " Normal block.
        for l:b in split(l:block, ',', 1)
          " Concat.
          let l:script .= l:head . escape(l:b, ' ') . ' '
        endfor
      endif
      let i = matchend(a:script, '{.*[^\\]}', i)
    else
      let [l:script, i] = s:skip_else(l:script, a:script, i)
    endif
  endwhile

  return l:script
endfunction"}}}
function! s:parse_tilde(script)"{{{
  let l:script = ''

  let i = 0
  let l:max = len(a:script)
  while i < l:max
    if a:script[i] == ' ' && a:script[i+1] == '~'
      " Tilde.
      " Expand home directory.
      let l:script .= ' ' . escape(substitute($HOME, '\\', '/', 'g'), '\ ')
      let i += 2
    elseif i == 0 && a:script[i] == '~'
      " Tilde.
      " Expand home directory.
      let l:script .= escape(substitute($HOME, '\\', '/', 'g'), '\ ')
      let i += 1
    else
      let [l:script, i] = s:skip_else(l:script, a:script, i)
    endif
  endwhile

  return l:script
endfunction"}}}
function! s:parse_equal(script)"{{{
  let l:script = ''

  let i = 0
  let l:max = len(a:script)
  while i < l:max - 1
    if a:script[i] == ' ' && a:script[i+1] == '='
      " Expand filename.
      let l:prog = matchstr(a:script, '^=\zs[^[:blank:]]*', i+1)
      if l:prog == ''
        let [l:script, i] = s:skip_else(l:script, a:script, i)
      else
        let l:filename = vimshell#getfilename(l:prog)
        if l:filename == ''
          throw printf('Error: File "%s" is not found.', l:prog)
        else
          let l:script .= l:filename
        endif

        let i += matchend(a:script, '^=[^[:blank:]]*', i+1)
      endif
    else
      let [l:script, i] = s:skip_else(l:script, a:script, i)
    endif
  endwhile

  return l:script
endfunction"}}}
function! s:parse_variables(script)"{{{
  let l:script = ''

  let i = 0
  let l:max = len(a:script)
  while i < l:max
    if a:script[i] == '$'
      " Eval variables.
      if match(a:script, '^$\l', i) >= 0
        let l:script .= string(eval(printf("b:vimshell.variables['%s']", matchstr(a:script, '^$\zs\l\w*', i))))
      elseif match(a:script, '^$$', i) >= 0
        let l:script .= string(eval(printf("b:vimshell.system_variables['%s']", matchstr(a:script, '^$$\zs\h\w*', i))))
      else
        let l:script .= string(eval(matchstr(a:script, '^$\h\w*', i)))
      endif
      let i = matchend(a:script, '^$$\?\h\w*', i)
    else
      let [l:script, i] = s:skip_else(l:script, a:script, i)
    endif
  endwhile

  return l:script
endfunction"}}}
function! s:parse_wildcard(script)"{{{
  let l:script = ''

  let i = 0
  let l:max = len(a:script)
  while i < l:max
    if a:script[i] == '[' || a:script[i] == '*' || a:script[i] == '?' || a:script[i :] =~ '^\\[()|]'
      " Wildcard.
      let l:head = matchstr(a:script[: i-1], '[^[:blank:]]*$')
      let l:wildcard = l:head . matchstr(a:script, '^[^[:blank:]]*', i)
      " Trunk l:script.
      let l:script = l:script[: -len(l:wildcard)]

      let l:script .= join(vimshell#parser#expand_wildcard(l:wildcard))
      let i = matchend(a:script, '^[^[:blank:]]*', i)
    else
      let [l:script, i] = s:skip_else(l:script, a:script, i)
    endif
  endwhile

  return l:script
endfunction"}}}
function! s:parse_redirection(script)"{{{
  let l:script = ''
  let l:fd = { 'stdin' : '', 'stdout' : '', 'stderr' : '' }

  let i = 0
  let l:max = len(a:script)
  while i < l:max
    if a:script[i] == '<'
      " Input redirection.
      let l:fd.stdin = matchstr(a:script, '<\s*\zs\f*', i)
      let i = matchend(a:script, '<\s*\zs\f*', i)
    elseif a:script[i] == '>'
      " Output redirection.
      if a:script[i :] =~ '^>&'
        let l:fd.stderr = matchstr(a:script, '>&\s*\zs\f*', i)
        let i = matchend(a:script, '>&\s*\zs\f*', i)
      elseif a:script[i :] =~ '^>>'
        let l:fd.stdout = '>' . matchstr(a:script, '>>\s*\zs\f*', i)
        let i = matchend(a:script, '>>\s*\zs\f*', i)
      else
        let l:fd.stdout = matchstr(a:script, '>\s*\zs\f*', i)
        let i = matchend(a:script, '>\s*\zs\f*', i)
      endif
    else
      let [l:script, i] = s:skip_else(l:script, a:script, i)
    endif
  endwhile

  return [l:fd, l:script]
endfunction"}}}

function! s:parse_single_quote(script, i)"{{{
  if a:script[a:i] != "'"
    return ['', a:i]
  endif

  let l:arg = ''
  let i = a:i + 1
  let l:max = len(a:script)
  while i < l:max
    if a:script[i] == "'"
      if i+1 < l:max && a:script[i+1] == "'"
        " Escape quote.
        let l:arg .= "'"
        let i += 2
      else
        " Quote end.
        return [l:arg, i+1]
      endif
    else
      let l:arg .= a:script[i]
      let i += 1
    endif
  endwhile

  throw 'Exception: Quote ('') is not found.'
endfunction"}}}
function! s:parse_double_quote(script, i)"{{{
  if a:script[a:i] != '"'
    return ['', a:i]
  endif

  let l:arg = ''
  let i = a:i + 1
  let l:max = len(a:script)
  while i < l:max
    if a:script[i] == '"'
      " Quote end.
      return [l:arg, i+1]
    elseif a:script[i] == '\'
      " Escape.
      let i += 1

      if i > l:max
        throw 'Exception: Join to next line (\).'
      endif

      let l:arg .= a:script[i]
      let i += 1
    else
      let l:arg .= a:script[i]
      let i += 1
    endif
  endwhile

  throw 'Exception: Quote (") is not found.'
endfunction"}}}
function! s:parse_back_quote(script, i)"{{{
  if a:script[a:i] != '`'
    return ['', a:i]
  endif

  let l:arg = ''
  let l:max = len(a:script)
  if a:i + 1 < l:max && a:script[a:i + 1] == '='
    " Vim eval quote.
    let i = a:i + 2

    while i < l:max
      if a:script[i] == '`'
        " Quote end.
        return [eval(l:arg), i+1]
      else
        let l:arg .= a:script[i]
        let i += 1
      endif
    endwhile
  else
    " Eval quote.
    let i = a:i + 1

    while i < l:max
      if a:script[i] == '`'
        " Quote end.
        return [vimshell#system(l:arg), i+1]
      else
        let l:arg .= a:script[i]
        let i += 1
      endif
    endwhile
  endif

  throw 'Exception: Quote (`) is not found.'
endfunction"}}}

" Skip helper.
function! s:skip_single_quote(script, i)"{{{
  let l:end = matchend(a:script, "^'[^']*'", a:i)
  if l:end == -1
    throw 'Exception: Quote ('') is not found.'
  endif
  return [matchstr(a:script, "^'[^']*'", a:i), l:end]
endfunction"}}}
function! s:skip_double_quote(script, i)"{{{
  let l:end = matchend(a:script, '^"\%([^"]\|\"\)*"', a:i)
  if l:end == -1
    throw 'Exception: Quote (") is not found.'
  endif
  return [matchstr(a:script, '^"\%([^"]\|\"\)*"', a:i), l:end]
endfunction"}}}
function! s:skip_back_quote(script, i)"{{{
  let l:end = matchend(a:script, '^`[^`]*`', a:i)
  if l:end == -1
    throw 'Exception: Quote (`) is not found.'
  endif
  return [matchstr(a:script, '^`[^`]*`', a:i), l:end]
endfunction"}}}
function! s:skip_else(args, script, i)"{{{
  if a:script[a:i] == "'"
    " Single quote.
    let [l:string, i] = s:skip_single_quote(a:script, a:i)
    let l:script = a:args . l:string
  elseif a:script[a:i] == '"'
    " Double quote.
    let [l:string, i] = s:skip_double_quote(a:script, a:i)
    let l:script = a:args . l:string
  elseif a:script[a:i] == '`'
    " Back quote.
    let [l:string, i] = s:skip_back_quote(a:script, a:i)
    let l:script = a:args . l:string
  elseif a:script[a:i] == '\'
    " Escape.
    let l:script = a:args . '\' . a:script[a:i+1]
    let i = a:i + 2
  else
    let l:script = a:args . a:script[a:i]
    let i = a:i + 1
  endif

  return [l:script, i]
endfunction"}}}

function! s:recursive_expand_alias(string)"{{{
  " Recursive expand alias.
  let l:alias = b:vimshell.alias_table[a:string]
  let l:expanded = {}
  while 1
    let l:key = vimshell#parser#split_args(l:alias)[-1]
    if has_key(l:expanded, l:alias) || !has_key(b:vimshell.alias_table, l:alias)
      break
    endif

    let l:expanded[l:alias] = 1
    let l:alias = b:vimshell.alias_table[l:alias]
  endwhile

  return l:alias
endfunction"}}}

" vim: foldmethod=marker
