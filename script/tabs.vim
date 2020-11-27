" VimTabs.vim - A vim plugin for writing guitar tablature
" Author: Andrew Kingery 
" Version: 0.2

let g:GAMERS = 1

echo "Gamertime"
if exists("g:loaded_VimTabs")
    finish
endif
let g:loaded_VimTabs = 1

let s:tuning=['e', 'B', 'G', 'D', 'A', 'E']

let s:Chords={
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
     
function! s:InitTab(length)
    execute "normal! i[]\<CR>\<CR>" 
    call s:DrawStrings(a:length)
    " reset position 
    execute "normal! ggl"
    startinsert
endfunction

function! s:DrawStrings(length) 
    for @s in g:tuning
        execute "normal! i\<C-R>s|\<C-o>". a:length. "a-\<esc>a|\<esc>o"
    endfor
endfunction

function! s:OnStringLine()
    return getline(line('.')) =~ "^[a-gA-G]\|.*-*.*" 
endfunction

function! s:OnStringChar()
    return s:OnStringLine() && getline('.')[col('.')-1] == "-" 
endfunction

function! s:HyphenDelete(type)
    silent execute "normal! `[v`]r-"
endfunction

function! s:HyphenChange(type)
    silent execute "normal! `[v`]r-"
    startgreplace
endfunction

function! s:ToFirstLine()
    noh
    execute "normal! ?". g:tuning[0]. "?s+". (col(".")-1). "\<CR>"
endfunction

function! s:Chord(Letter)
    normal mm
    call s:ToFirstLine()
    set ve=all
    execute "normal! kR". a:Letter. "\<esc>j" 
    set ve=
    for @r in s:Chords[a:Letter]
        execute "normal! s\<C-R>r\<esc>j"
    endfor
    normal `m
endfunction

" Mapping for String Lines

" chord completion
let maplocalleader = "-"
for c in keys(s:Chords)
    execute "nnoremap <localleader>". c." :call <SID>Chord(\"". c. "\")<CR>"
endfor

" selections
nnoremap <expr> <S-v> s:OnStringLine() ? ':call <SID>ToFirstLine()<CR><C-v>5j':'<S-v>'
nmap <expr> yy s:OnStringLine() ? 'mm<S-v>y`m':'yy'

" movement
inoremap <expr> <Tab> s:OnStringLine() ? '<esc>jgR':'<Tab>'
inoremap <expr> <S-Tab> s:OnStringLine() ? '<esc>kgR':'<Tab>'

" map insert mode to Replace mode if cursor on a string line
nnoremap <expr> i s:OnStringChar() ? 'gR':'i'
nnoremap <expr> a s:OnStringLine() ? 'lgR':'a'
nnoremap <expr> I s:OnStringLine() ? 'T\|gR':'I'
inoremap <expr> <space> s:OnStringLine() ? '-':'<space>'

" replace deleted things with hyphens
nnoremap <silent> <expr> d s:OnStringLine() ? ':set opfunc=<SID>HyphenDelete<CR>g@':'d'
vnoremap <expr> d s:OnStringLine() ? 'r-':'d'
nnoremap <silent> <expr> c s:OnStringLine() ? ':set opfunc=<SID>:HyphenChange<CR>g@':'c'
vnoremap <expr> c s:OnStringLine() ? 'r-gR':'d'
nnoremap <expr> C s:OnStringLine() ? 'v$r-gR':'C'
nnoremap <expr> x s:OnStringLine() ? 'r-':'x'
nnoremap <expr> s s:OnStringLine() ? 'r-gR':'s'

autocmd BufNewFile *.tab call s:InitTab(60)
