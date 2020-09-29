function! s:DeleteSurrounding(char_num) abort
  let saved_unnamed_register = @@
  let char = nr2char(a:char_num)
  silent execute "normal! " . "vi" . char . "\e"
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  if line_start ==# line_end
    silent execute "normal! " . "di" . char . "vh" . "p"
  else
    let old_sw = &sw
    set sw=1
    silent execute "normal! " . "di" . char . "vh" . "p" . "j" . line_end . "<gg"
    let &sw = old_sw
  endif
  let @@ = saved_unnamed_register
endfunction

function! s:SurroundWithChars(vmode, line_start, line_end, column_start, column_end, char1, char2) abort
  if a:line_start ==# a:line_end
    let insertBeginning = join([a:column_start, '|', 'i', a:char1], "")
    " NOTE: when vmode is 'V', column_end is some arbitrary big number
    let insertEnd = a:vmode ==# 'v'
                    \ ? join([a:column_end, '|l', 'a', a:char2], "")
                    \ : join(['A', a:char2], "")
    silent execute 'normal! ' . insertBeginning . "\e" . insertEnd
  else
    let insertBeginning = join([a:line_start, 'gg',
                               \ a:column_start, '|',
                               \ 'i', a:char1], "")
    " NOTE: when vmode is 'V', column_end is some arbitrary big number
    let insertEnd = a:vmode ==# 'v'
                    \ ? join(['j', a:line_end, '>gg',
                             \ a:line_end, 'gg',
                             \ a:column_end, '|',
                             \ 'la', a:char2], "")
                    \ : join(['j', a:line_end, '>gg',
                             \ a:line_end, 'gg',
                             \ "A", a:char2], "")
    let old_sw = &sw
    set sw=1
    silent execute 'normal! ' . insertBeginning . "\e" . insertEnd
    let &sw = old_sw
  endif
endfunction

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

function! s:ChangeSurround(old_char, new_char) abort
  let saved_unnamed_register = @@
  let old = nr2char(a:old_char)
  let new = nr2char(a:new_char)
  let [open_char, close_char] = <SID>ChooseChars(new)
  silent execute "normal! " . "di" . old . "r" . close_char . "hr" . open_char . "p"
  let @@ = saved_unnamed_register
endfunction

function! s:SurroundWith(vmode, char_num) abort
  let char = nr2char(a:char_num)
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let [open_char, close_char] = <SID>ChooseChars(char)
  call <SID>SurroundWithChars(a:vmode, line_start, line_end, column_start, column_end, open_char, close_char)
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
