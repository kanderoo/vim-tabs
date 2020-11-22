" VimTabs.vim - A vim plugin for writing guitar tablature
" Author: Andrew Kingery 
" Version: 0.1

function! DrawStrings(length) 
    for @s in ['e', 'B', 'G', 'D', 'A', 'E']
        execute "normal! i\<C-R>s|\<C-o>". a:length. "a-\<esc>o"
    endfor
    " reset position
    normal! ggl 
endfunction

autocmd BufNewFile *.tab call DrawStrings(50)
