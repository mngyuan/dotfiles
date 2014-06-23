set nocompatible

" plugin fun
execute pathogen#infect()
call pathogen#helptags()
syntax on
filetype plugin indent on
" NERDtree
map <C-e> :NERDTreeToggle<CR>
" gitgutter
let g:gitgutter_sign_column_always = 1	" always show diff col
let g:gitgutter_realtime = 1	" constantly show git diff
" statusline - use with airline
let g:airline_powerline_fonts = 1	" pretty arrows

set backspace=indent,eol,start
				" allow backspacing over everything

" set nowrap	" don't wrap lines
" not crazy person style word wrapping
set wrap
set linebreak
set nolist

set autoindent
set copyindent	" copy prev indentation when autoindenting
set number
set showmatch	" show matching parens

set ignorecase	" ignore case in search
set smartcase	" ignore case if all low caps
				"otherwise, pay attention to caps
set ssop-=folds		" do not store folds


set shiftwidth=4
set shiftround	" use multiples of shiftwidth with < and >
set tabstop=4
set softtabstop=4
set smarttab	" insert tabs on start of line according to shiftwidth
				" not tabstop
set ruler

set hlsearch	" highlight search terms
set incsearch	" show search matches while typing
nnoremap <esc> :noh<return><esc>
				" press esc to end highlighting

set history=1000
set undolevels=1000
" set visualbell	" stop beeping me
set noerrorbells
				" really stop beeping me

set clipboard=unnamed
				" use system clipboard

set nobackup
set noswapfile	" live on the edge man #git

set autochdir	" set cwd to cur buffer's loc
autocmd BufEnter * silent! lcd %:p:h
				" set cwd to cur buffer's loc, for plugin

" gvim options
set guioptions-=m " menu bar
set guioptions-=T " toolbar
set guioptions-=r " righthand scroll bar
set guioptions-=L " lefthand scroll bar

" solve carpal tunnel
nnoremap ; :

" stop bein a god-damned n00b
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" coloring and fonts
set t_Co=256
syntax enable
set background=dark
colorscheme molokai
if has("win32") || has("win16")
	set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h8
else
	set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12
endif

" highlighting and syntax
au BufRead,BufNewFile *.md set filetype=markdown	" highlighting for markdown
au BufRead,BufNewFile *.ejs set filetype=html		" highlight for ejs
" prefer 2 tabsize for web/frontend stuff
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2

set ssop-=options	" do not store global/local vars in sessions
