" VimTabs.vim - A vim plugin for writing guitar tablature
" Author: Andrew Kingery 
" Version: 0.2

function! DrawStrings(length) 
    for @s in ['e', 'B', 'G', 'D', 'A', 'E']
        execute "normal! i\<C-R>s|\<C-o>". a:length. "a-\<esc>o"
    endfor
    " reset position
    normal! ggl 
endfunction

" map insert mode to Replace mode if cursor on a string line
nnoremap <expr> i getline(line('.')) =~ "^[a-zA-Z]\|" && getline('.')[col('.')-1] == "-" ? 'R':'i'

autocmd BufNewFile *.tab call DrawStrings(50)
