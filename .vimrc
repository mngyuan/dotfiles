set nocompatible

set backspace=indent,eol,start
				" allow backspacing over everything
set nowrap		" don't wrap lines
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

set nobackup
set noswapfile	" live on the edge man #git

set autochdir	" set cwd to cur buffer's loc

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

set t_Co=256
syntax enable
colorscheme molokai
set guifont=DejaVu\ Sans\ Mono:h10
au BufRead,BufNewFile *.md set filetype=markdown " syntax highlighting for markdown

set ssop-=options	" do not store global/local vars in sessions
