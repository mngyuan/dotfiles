let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'json': ['prettier'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\   'typescript': ['prettier', 'eslint'],
\}
let g:ale_fix_on_save = 1
let g:ale_sign_error = '>'
let g:ale_sign_warning = '-'

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
