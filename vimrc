" phorust vimrc

set nocompatible
filetype off

"***** PLUGINS *****
" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')
" powerful, light statusline
Plug 'bling/vim-airline'
" git symbols in the left margin
Plug 'airblade/vim-gitgutter'
" directory exploration
Plug 'scrooloose/nerdtree'
" multiline commenting
Plug 'scrooloose/nerdcommenter'
" git, inside vim, if you can remember the commands
Plug 'tpope/vim-fugitive'
if has('nvim')
  " completions
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " linting
  Plug 'w0rp/ale'
elseif v:version >= 800
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
" javascript completion
Plug 'marijnh/tern_for_vim'
" javascript type checking
Plug 'facebook/vim-flow'
" javascript coloring
Plug 'othree/yajs.vim'
" HTML5 coloring
Plug 'othree/html5.vim'
" JSX
Plug 'mxw/vim-jsx'
" Load language plugins on demand
" Plug 'sheerun/vim-polyglot'
" vim navigation for tmux
Plug 'christoomey/vim-tmux-navigator'
" automatically detect indentation
Plug 'tpope/vim-sleuth'
" indentation guides
Plug 'nathanaelkane/vim-indent-guides'
" automatically save a Session.vim, for tmux-resurrect
Plug 'tpope/vim-obsession'
" ctrl-p fuzzy searching
Plug 'kien/ctrlp.vim'
" better fuzzy searching
Plug 'wincent/command-t', { 'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make' }
" signs for hg
Plug 'mhinz/vim-signify'
" search should show Match n of N
Plug 'henrik/vim-indexed-search'
" align things nicely
Plug 'godlygeek/tabular'
" nice code review
Plug 'phleet/vim-arcanist'
" fav colors
Plug 'mhartington/oceanic-next'
Plug 'tomasr/molokai'
Plug 'benjaminwhite/Benokai'
Plug 'vyshane/vydark-vim-color'
Plug 'ajh17/Spacegray.vim'
Plug 'effkay/argonaut.vim'
Plug 'chankaward/vim-railscasts-theme'
Plug 'blerins/flattown'
Plug 'whatyouhide/vim-gotham'
Plug 'sjl/badwolf'
Plug 'morhetz/gruvbox'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'w0ng/vim-hybrid'
Plug 'jordwalke/flatlandia'
Plug 'junegunn/seoul256.vim'
call plug#end()
filetype plugin indent on

" fb: these take 1s to load so im disabling
"if filereadable("/home/engshare/admin/scripts/vim/fbvim.vim")
	"source /home/engshare/admin/scripts/vim/fbvim.vim
	"source /home/engshare/admin/scripts/vim/biggrep.vim
"endif

"***** REMAPPINGS *****
" solve carpal tunnel
nnoremap ; :
" stop bein a god-damned n00b
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
" copy to system clipboard
vmap <C-c> :w !pbcopy<CR><CR>
vmap <C-v> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
map <leader>v :set paste!<CR>
" reselect after shift
vnoremap < <gv
vnoremap > >gv

" better tab movement
nmap <silent> <C-n> :tabnext<CR>
nmap <silent> <C-b> :tabprev<CR>
" trailing whitespace
nnoremap <silent> <leader>rtw :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" this causes errors with drawing... or something. disabled.
"nnoremap <esc> :noh<return><esc>	" press esc to end highlighting
nnoremap <silent> <leader><esc> :nohls<cr><c-l>	" press \<esc> to end hl
" the CAPS LOCK key as ESC on an apple keyboard sometimes doesn't work so
imap ;w<CR> <ESC>:w<CR>

" plugin specific
" fugitive / gitgutter
map <leader>gd :Gdiff<CR>
map <leader>gb :Gblame<CR>
map <leader>gg :Gbrowse<CR> " Git Github
" vim-signify literally takes 1 whole second on save
map <leader>s :SignifyToggle<CR>
" not gj, gk cuz that takes too long
nmap <leader>j <Plug>GitGutterNextHunk
nmap <leader>k <Plug>GitGutterPrevHunk
" press - to stage/reset
map <leader>gs :Gstatus<CR>
map <leader>gc :Gcommit<CR>
" fix quickfix things
map <leader>h :cp<CR>
map <leader>l :cn<CR>
" nnoremap <c-g> :GitGutterToggle<CR><c-g>
" NERDtree
map <leader>e :NERDTreeToggle<CR>
map <leader>r :NERDTreeFind<CR>
" visually align things
vmap <leader>a= :Tabularize /=<CR>
vmap <leader>a: :Tabularize /:<CR>
vmap <leader>a\| :Tabularize /\|<CR>
vmap <leader>a" :Tabularize /"<CR>
vmap <leader>a< :Tabularize /<<CR>
vmap <leader>a/ :Tabularize / \/\/<CR>

" deoplete tab-complete
if has('nvim') || v:version >= 800
  inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
endif
" otherwise use dumb completion
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

"***** BASIC VIM SETTINGS *****
set laststatus=2		" always show statusline

set backspace=indent,eol,start	" allow backspacing over everything

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
		"   otherwise, pay attention to caps
set ssop-=folds	" do not store folds


set ruler
set scrolloff=5	" always show at least 5 lines above/below cursor
set scrolljump=5	" scroll by 5 lines at a time
set cc=80

set hlsearch	" highlight search terms
set incsearch	" show search matches while typing

set history=10000
set undolevels=1000
" don't beep me
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" set clipboard=unnamed,unnamedplus	" use system clipboard on win,unix

set nobackup
set noswapfile 				" live on the edge man #git

set autochdir 				" set cwd to cur buffer's loc
"autocmd BufEnter * silent! lcd %:p:h	" set cwd to cur buffer's loc,
					" was for NERDTree but dont need
" autochdir and it's friends don't play well with tmux-resurrect...

" gvim options
set guioptions-=m " menu bar
set guioptions-=T " toolbar
set guioptions-=r " righthand scroll bar
set guioptions-=L " lefthand scroll bar

" holy fuck why have i been in the dark ages
set mouse=a
set undofile
set undodir=~/.vimundo/ " this directory must exist

set ssop-=options	" do not store global/local vars in sessions

set wildignore=*.o,*~,*.pyc " ignore compiled files

" jump to last position on file open
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\""

"***** FONT AND COLOR *****
set t_Co=256
if (has("termguicolors"))
  set termguicolors
endif
" set background=dark
syntax enable
colorscheme badwolf
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
if has("gui_running")
	if has("gui_win32")
		set encoding=utf-8
		set guifont=DejaVu_Sans_Mono_for_Powerline:h10
	elseif has("gui_macvim")
		set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12
	elseif has("gui_gtk2")
		set guifont=DejaVu\ Sans\ Mono\ for\ Powerline
	endif
endif
" | as cursor in insert mode instead of block
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

" highlighting and syntax
au! BufRead,BufNewFile *.md   set filetype=markdown	" highlighting for markdown
au! BufRead,BufNewFile *.ejs  set filetype=html		  " highlight for ejs
au! BufRead,BufNewFile *.txt  set filetype=text
au! BufRead,BufNewFile README set filetype=text
" prefer 2 tabsize for web/frontend stuff
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2
set list	"see whitespace"
" set listchars=tab:→\ ,trail:· " the tab arrows are just too ugly
set listchars=tab:\ \ ,trail:·


"***** PLUGIN SETTINGS *****
syntax on
" gitgutter
" let g:gitgutter_sign_column_always = 1	" always show diff col
let g:gitgutter_realtime = 1	" constantly show git diff
" use signify for everything that isn't git
" except it's fucking a slow piece of shit
let g:signify_disable_by_default = 1
let g:signify_vcs_list = [ 'hg', 'perforce', 'svn' ]
let g:signify_sign_change = "~"
" statusline - use with airline
let g:airline_powerline_fonts = 1	" pretty arrows
autocmd CompleteDone * pclose 	" close [Scratch] [Preview] split after completion
let g:flow#autoclose = 1				" close quickfix after vim-flow check
let g:jsx_ext_required = 0 " always allow jsx highlighting
" ycm style autocomplete for deoplete & tern
autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>
" from ziggy
if filereadable("/home/engshare/admin/scripts/vim/fbvim.vim")
  let g:CommandTInputDebounce=50
  let g:CommandTFileScanner='watchman'
  let g:CommandTSmartCase = 1
  let g:CommandTMaxCachedDirectories = 1000
endif
" show indents
let g:indent_guides_enable_on_vim_startup=1
