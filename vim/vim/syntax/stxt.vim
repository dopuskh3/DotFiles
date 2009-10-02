"" Vim syntax file
" Language:     text
" Maintainer:   François Visconte <fv@kh3.org>
" Last Change:  2005 November 15

" To use this syntax file:
" 1. mkdir ~/.vim/syntax
" 2. mv ~/wiki.vim ~/.vim/syntax/wiki.vim
" 3. :set syntax=wiki 
"

" Quit if syntax file is already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
e Vim syntax file
endif

syn	region  txtLink		start=+\[+hs=s+1 end=+\]+he=e-1
syn	region  txtPuce		start="^\s*[-+.]" end="\s"
syn	region  txtSnippet	start="^\s*[-=#]\+<snip>[-=#]\+$" end="^\s*[-=#]\+<\/snip>[-=#]\+$"
syn	match   txtEmailAddr    /[a-zA-Z0-9-_.]\+@[a-zA-Z0-9]\+\.[a-zA-Z0-9]\{2,3}/
syn	match   txtUrl		/\(http\|ftp\|ssh\)\:\/\/[a-zA-Z0-9-_.\/\&\?\~]\+/
syn	match	txtTitle	/^\s*[-|=]*$/  " hs=s+1,he=e-1
syn	region	txtBold		start="\s\*\S" end="*\s"
syn	match	txtUnderline	/__.*__/
syn	match	txtFixme	/FIXME/
syn	match	txtTitleChapter /^\s*\([0-9]\+\.*\)\+ \+.*$/
syn	match	txtTitleChapter /^\s*\([Cc]hapter\|[cC]hapitre\|[sS]ection\)\{1}\s*\([0-9]\+\.\)\+\s*.*$/
  
  
hi def    link    txtSnippet	    PreProc
hi def    link    txtEmailAddr	    Underlined 
hi def    link    txtUrl	    Underlined
hi def    link    txtTitle	    Type
hi def    link    txtTitleChapter   Type
hi def    link    txtBold	    Identifier
hi def    link    txtFixme	    Error

let b:current_syntax = "stxt"
