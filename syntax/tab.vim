" Vim syntax file

if exists('b:current_syntax')
    finish
endif

" Syntax Regular Expressions
syntax match Header /^\[.*\]/

syntax match StringBorder /^[a-gA-G]|/
syntax match StringBorder /-*|/

syntax match EmptyString /-/

syntax match Slide /\d\/\d+/
syntax match Slide /\d\\\d+/

syntax match HammerOn /\dh\d/
syntax match PullOff /\dp\d/


" Highlight Links
hi def link Header SpecialChar
hi def link StringBorder String
hi def link EmptyString Comment
hi def link ChordHeader SpecialComment
hi def link Slide Operator
hi def link HammerOn Operator
hi def link PullOff Operator

let b:current_syntax = "tab"
