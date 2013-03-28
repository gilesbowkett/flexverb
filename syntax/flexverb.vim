" Vim syntax file
" Language: FlexVerb
" Latest Revision: https://github.com/gilesbowkett/flexverb

if exists("b:current_syntax")
  finish
endif

syn match fvOpenMarker 'verb('
syn match fvOpenMarker 'v('
syn match fvOpenMarker 'direct-object('
syn match fvOpenMarker 'o('
syn match fvCloseMarker ')'
hi def link fvOpenMarker Comment
hi def link fvCloseMarker Comment

syn match fvSingleString /'[^']\+'/
hi def link fvSingleString String
syn match fvDoubleString /"[^"]\+"/
hi def link fvDoubleString String

syn keyword fvPrint print
hi def link fvPrint Keyword

