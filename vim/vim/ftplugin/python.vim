set omnifunc=syntaxcomplete#Complete
inoremap <C-P> <C-X><C-O>

" Python-mode configuration
"
let g:pymode_rope = 0
" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'
" Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pylint,pep8"
" Auto check on save
let g:pymode_lint_write = 1
" Support virtualenv
let g:pymode_virtualenv = 1
" Enable breakpoints plugin
" let g:pymode_breakpoint = 1
" let g:pymode_breakpoint_key = '<leader>b'
"
" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all
" Don't autofold code
" let g:pymode_folding = 0

" Jedi configuration:
" 
let g:jedi#autocompletion_command = "<C-Space>"

highlight Excess ctermbg=DarkGrey guibg=Black
match Excess /\%100v.*/
set tags+=python_tags,tags
set tags+=./python_tags
 
