" VimTabs.vim - A vim plugin for writing guitar tablature
" Author: Andrew Kingery 
" Version: 0.2

function! InitTab(length)
    execute "normal! i[]\<CR>" 
    call DrawStrings(a:length)
    " reset position
    execute "normal! ggl"
    startinsert
endfunction

function! DrawStrings(length) 
    for @s in ['e', 'B', 'G', 'D', 'A', 'E']
        execute "normal! i\<C-R>s|\<C-o>". a:length. "a-\<esc>o"
    endfor
endfunction

function! OnStringLine()
    return getline(line('.')) =~ "^[a-gA-G]\|" 
endfunction

function! OnStringChar()
    return OnStringLine() && getline('.')[col('.')-1] == "-" 
endfunction

function! HyphenDelete(type)
    silent execute "normal! `[v`]r-"
endfunction

function! HyphenChange(type)
    silent execute "normal! `[v`]r-"
    startgreplace
endfunction

" Mapping for String Lines

" map insert mode to Replace mode if cursor on a string line
nnoremap <expr> i OnStringChar() ? 'gR':'i'
nnoremap <expr> a OnStringLine() ? 'lgR':'a'
nnoremap <expr> I OnStringLine() ? 'T\|gR':'I'
inoremap <expr> <space> OnStringLine() ? '-':'<space>'

" replace deleted things with hyphens
nnoremap <silent> <expr> d OnStringLine() ? ':set opfunc=HyphenDelete<CR>g@':'d'
nnoremap <silent> <expr> c OnStringLine() ? ':set opfunc=HyphenChange<CR>g@':'c'

autocmd BufNewFile *.tab call InitTab(50)
