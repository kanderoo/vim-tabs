" VimTabs.vim - A vim plugin for writing guitar tablature
" Author: Andrew Kingery 
" Version: 0.2

if exists("g:loaded_VimTabs")
    finish
endif
let g:loaded_VimTabs = 1

let s:tuning=['e', 'B', 'G', 'D', 'A', 'E']

function! s:InitTab(length)
    execute "normal! i[]\<CR>\<CR>" 
    call s:DrawStrings(a:length)
    " reset position 
    execute "normal! ggl"
    startinsert
endfunction

function! tabs#DrawStrings(length)
    for @s in s:tuning
        execute "normal! i\<C-R>s|\<C-o>". a:length. "a-\<esc>a|\<esc>o"
    endfor
endfunction

function! s:OnStringLine()
    return getline(line('.')) =~ "^[a-gA-G]\|.*-*.*" 
endfunction

function! s:OnStringChar()
    return s:OnStringLine() && getline('.')[col('.')-1] == "-" 
endfunction

function! s:OnFirstLine()
    return getline('.')[0:1] == s:tuning[0]."|"
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
    if s:OnFirstLine()
        return
    endif
    execute "normal! ?". s:tuning[0]. "?s+". (col(".")-1). "\<CR>"
endfunction

function! s:Chord(Letter)
    normal mm
    call s:ToFirstLine()
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
for c in keys(g:Chords)
    execute "nnoremap <localleader>". c." :call <SID>Chord(\"". c. "\")<CR>"
endfor

" selections
nnoremap <expr> <S-v> <SID>OnStringLine() ? ':call <SID>ToFirstLine()<CR><C-v>5j':'<S-v>'
nmap <expr> yy <SID>OnStringLine() ? 'mm<S-v>y`m':'yy'

" movement
inoremap <expr> <Tab> <SID>OnStringLine() ? '<esc>jgR':'<Tab>'
inoremap <expr> <S-Tab> <SID>OnStringLine() ? '<esc>kgR':'<Tab>'

" map insert mode to Replace mode if cursor on a string line
nnoremap <expr> i <SID>OnStringChar() ? 'gR':'i'
nnoremap <expr> a <SID>OnStringLine() ? 'lgR':'a'
nnoremap <expr> I <SID>OnStringLine() ? 'T\|gR':'I'
inoremap <expr> <space> <SID>OnStringLine() ? '-':'<space>'

" replace deleted things with hyphens
nnoremap <silent> <expr> d <SID>OnStringLine() ? ':set opfunc=<SID>HyphenDelete<CR>g@':'d'
vnoremap <expr> d <SID>OnStringLine() ? 'r-':'d'
nnoremap <silent> <expr> c <SID>OnStringLine() ? ':set opfunc=<SID>:HyphenChange<CR>g@':'c'
vnoremap <expr> c <SID>OnStringLine() ? 'r-gR':'d'
nnoremap <expr> C <SID>OnStringLine() ? 'v$r-gR':'C'
nnoremap <expr> x <SID>OnStringLine() ? 'r-':'x'
nnoremap <expr> s <SID>OnStringLine() ? 'r-gR':'s'

if !filereadable(expand('%'))
    call s:InitTab(60)
endif
