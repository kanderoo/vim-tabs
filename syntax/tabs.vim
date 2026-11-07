" Vim syntax file

if exists('b:current_syntax')
    finish
endif

syntax match tabsHeader /^\[.*\]/

" Only string lines get tab highlighting, so lyrics and comments stay plain.
syntax match tabsString /^[a-gA-G]|.*/ contains=tabsHyphen,tabsFret,tabsTechnique,tabsMute,tabsHarmonic,tabsBar,tabsName
syntax match tabsHyphen /-/ contained
syntax match tabsFret /\d\+/ contained
syntax match tabsTechnique "[hpbrt/\\~]" contained
syntax match tabsMute /x/ contained
syntax match tabsHarmonic /<\d\+>/ contained
syntax match tabsBar /|/ contained
" Last, so it wins over tabsTechnique for a 'b|' string.
syntax match tabsName /^[a-gA-G]\ze|/ contained

" Very magic pieces for the patterns below. A chord is a root, then quality
" and extensions: Am, C7, Emaj7, Amin, CM7, F#m7b5, Dsus4, C/G.
let s:chord = '[A-G][#b]?(maj|min|dim|aug|sus|add|m|[0-9#b+/A-GM])*'
let s:string_below = '\ze\n[a-gA-G]\|'
execute 'syntax match tabsChords ,\v^\s*(' . s:chord . '\s*)+' . s:string_below . ', contains=tabsChord'
execute 'syntax match tabsChord ,\v' . s:chord . ', contained'
unlet s:chord s:string_below

hi def link tabsHeader Title
hi def link tabsName Identifier
hi def link tabsHyphen Comment
hi def link tabsFret Number
hi def link tabsTechnique Operator
hi def link tabsMute Special
hi def link tabsHarmonic Special
hi def link tabsBar Delimiter
hi def link tabsChord SpecialComment

let b:current_syntax = 'tabs'
