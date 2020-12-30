function! s:ChooseChars(char) abort
  if a:char ==# '(' || a:char ==# ')'
    return ['(', ')']
  elseif a:char ==# '[' || a:char ==# ']'
    return ['[', ']']
  elseif a:char ==# '{' || a:char ==# '}'
    return ['{', '}']
  else
    return [a:char, a:char]
  endif
endfunction

function! s:GetcharAtPosition() abort
  return strcharpart(strpart(getline('.'), col('.') - 1), 0, 1)
endfunction

" TODO: test if the char is a " or ' and then behave differently for that one
function! s:DeleteSurrounding(char_num) abort
  let saved_unnamed_register = @@
  let char = nr2char(a:char_num)
  let [open_char, close_char] = <SID>ChooseChars(char)

  if open_char ==# '(' || open_char ==# '[' || open_char ==# '{'
    silent execute "normal! " . "va" . char . "\e"
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    silent execute "normal! " . line_end . "gg" . column_end . "|" . "x" .
                              \ line_start . "gg" . column_start . "|" . "x"
  else
    silent execute "normal! " . "vi" . char . "y" . "\e"
    silent execute "normal! " . "v2i" . char . "p" . "\e"
  endif
  let @@ = saved_unnamed_register
endfunction

function! s:ChangeSurround(old_char, new_char) abort
  let old = nr2char(a:old_char)
  let new = nr2char(a:new_char)
  let [open_char, close_char] = <SID>ChooseChars(new)

  if open_char ==# '(' || open_char ==# '[' || open_char ==# '{'
    silent execute "normal! " . "va" . old . "\e"
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    silent execute "normal! " . line_start . "gg" . column_start . "|" . "r" . open_char .
                              \ line_end . "gg" . column_end . "|" . "r" . close_char
  else
    silent execute "normal! " . "vi" . old . "\e"
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    if old ==# s:GetcharAtPosition()
      silent execute "normal! " . column_start . "|" . "r" . new
                                \ column_end . "|" . "r" . new
    else
      silent execute "normal! " . column_end . "|l" . "r" . new .
                                \ column_start . "|h" . "r" . new
    endif
  endif
endfunction

function! s:SurroundWith(vmode, char_num) abort
  let char = nr2char(a:char_num)
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let [open_char, close_char] = <SID>ChooseChars(char)
  if a:vmode ==# "v"
    silent execute "normal! " . line_end . "gg" . column_end . "|" . "a" . close_char . "\e" .
                              \ line_start . "gg" . column_start . "|" . "i" . open_char
  elseif a:vmode ==# "V"
    silent execute "normal! " . line_end . "gg" . "o" . close_char . "\e" .
                              \ line_start . "gg" . "O" . open_char
  endif
endfunction

function! s:SurroundLine(char_num) abort
  let char = nr2char(a:char_num)
  let [open_char, close_char] = <SID>ChooseChars(char)
  silent execute "normal! " . "I" . open_char
  silent execute "normal! " . "A" . close_char
endfunction

nnoremap <silent> ds :call <SID>DeleteSurrounding(getchar())<CR>
vnoremap <silent> S :<C-U>call <SID>SurroundWith(visualmode(), getchar())<CR>
nnoremap <silent> yss :call <SID>SurroundLine(getchar())<CR>
nnoremap <silent> cs :call <SID>ChangeSurround(getchar(), getchar())<CR>
