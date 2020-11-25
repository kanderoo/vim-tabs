" VimTabs.vim - A vim plugin for writing guitar tablature
" Author: Andrew Kingery 
" Version: 0.2

let tuning=['e', 'B', 'G', 'D', 'A', 'E']

let Chords={
\    "A": ["0", "2", "2", "2", "0"],
\    "B": ["2", "4", "4", "4", "2"],
\    "C": ["0", "1", "0", "2", "3"],
\    "D": ["2", "3", "2", "0"],
\    "E": ["0", "0", "1", "2", "2", "0"],
\    "F": ["1", "1", "2", "3", "3", "1"],
\    "G": ["1", "0", "0", "0", "2", "3"],
\    "Am": ["0", "1", "2", "2", "0"],
\    "Bm": ["2", "3", "4", "4", "2"],
\    "Cm": ["3", "4", "5", "5", "3"],
\    "Dm": ["1", "3", "2", "0"],
\    "Em": ["0", "0", "0", "2", "2", "0"],
\    "Fm": ["1", "1", "1", "3", "3", "1"],
\    "Gm": ["3", "3", "3", "5", "5", "3"]
\}
     
function! InitTab(length)
    execute "normal! i[]\<CR>\<CR>" 
    call DrawStrings(a:length)
    " reset position 
    execute "normal! ggl"
    startinsert
endfunction

function! DrawStrings(length) 
    for @s in g:tuning
        execute "normal! i\<C-R>s|\<C-o>". a:length. "a-\<esc>a|\<esc>o"
    endfor
endfunction

function! OnStringLine()
    return getline(line('.')) =~ "^[a-gA-G]\|.*-*.*" 
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

function! ToFirstLine()
    noh
    execute "normal! ?". g:tuning[0]. "?s+". (col(".")-1). "\<CR>"
endfunction

function! Chord(Letter)
    normal mm
    call ToFirstLine()
    set ve=all
    execute "normal! kR". a:Letter. "\<esc>j" 
    set ve=
    for @r in g:Chords[a:Letter]
        execute "normal! s\<C-R>r\<esc>j"
    endfor
    normal `m
endfunction

" Mapping for String Lines

" chord completion
let maplocalleader = "-"
for c in keys(Chords)
    execute "nnoremap <localleader>". c." :call Chord(\"". c. "\")<CR>"
endfor

" selections
nnoremap <expr> <S-v> OnStringLine() ? ':call ToFirstLine()<CR><C-v>5j':'<S-v>'
nmap <expr> yy OnStringLine() ? 'mm<S-v>y`m':'yy'

" movement
inoremap <expr> <Tab> OnStringLine() ? '<esc>jgR':'<Tab>'
inoremap <expr> <S-Tab> OnStringLine() ? '<esc>kgR':'<Tab>'

" map insert mode to Replace mode if cursor on a string line
nnoremap <expr> i OnStringChar() ? 'gR':'i'
nnoremap <expr> a OnStringLine() ? 'lgR':'a'
nnoremap <expr> I OnStringLine() ? 'T\|gR':'I'
inoremap <expr> <space> OnStringLine() ? '-':'<space>'

" replace deleted things with hyphens
nnoremap <silent> <expr> d OnStringLine() ? ':set opfunc=HyphenDelete<CR>g@':'d'
vnoremap <expr> d OnStringLine() ? 'r-':'d'
nnoremap <silent> <expr> c OnStringLine() ? ':set opfunc=HyphenChange<CR>g@':'c'
vnoremap <expr> c OnStringLine() ? 'r-gR':'d'
nnoremap <expr> C OnStringLine() ? 'v$r-gR':'C'
nnoremap <expr> x OnStringLine() ? 'r-':'x'
nnoremap <expr> s OnStringLine() ? 'r-gR':'s'

autocmd BufNewFile *.tab call InitTab(60)
