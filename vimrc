" phorust vimrc

set nocompatible
filetype off

"***** PLUGINS *****
call plug#begin('~/.vim/plugged')
" powerful, light statusline
Plug 'bling/vim-airline'
" git symbols in the left margin
Plug 'airblade/vim-gitgutter'
" directory exploration
Plug 'scrooloose/nerdtree'
" git extension for nerdtree
Plug 'Xuyuanp/nerdtree-git-plugin'
" multiline commenting
Plug 'scrooloose/nerdcommenter'
" git, inside vim, if you can remember the commands
Plug 'tpope/vim-fugitive'
if has('nvim') || (v:version >= 800 && has('python3'))
  " linting
  Plug 'dense-analysis/ale'
endif
if has('nvim')
  " completions
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
elseif v:version >= 800 && has('python3')
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
" disabled while testing COC
" let g:deoplete#enable_at_startup = 1
" javascript completion
" Plug 'marijnh/tern_for_vim'
" javascript type checking
Plug 'facebook/vim-flow'
" javascript coloring
Plug 'othree/yajs.vim'
" HTML5 coloring
Plug 'othree/html5.vim'
" JSX
Plug 'maxmellon/vim-jsx-pretty'
" Typescript
Plug 'leafgarland/typescript-vim'
" Typescript + JSX
Plug 'peitalin/vim-jsx-typescript'
" YAML
Plug 'stephpy/vim-yaml'
" Load language plugins on demand
" Plug 'sheerun/vim-polyglot'
" vim navigation for tmux
Plug 'christoomey/vim-tmux-navigator'
" focus gain/loss events, needed for vim-tmux-clipboard
Plug 'tmux-plugins/vim-tmux-focus-events'
" use tmux's clipboard in vim (for copypaste between panes)
Plug 'roxma/vim-tmux-clipboard'
" automatically detect indentation
Plug 'tpope/vim-sleuth'
" indentation guides
Plug 'nathanaelkane/vim-indent-guides'
" automatically save a Session.vim, for tmux-resurrect
Plug 'tpope/vim-obsession'
" ctrl-p fuzzy searching
Plug 'ctrlpvim/ctrlp.vim'
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
" CSS color previews
Plug 'ap/vim-css-color'
" surround things with quotes, etc easily
Plug 'tpope/vim-surround'
" LSP support
"Plug 'autozimu/LanguageClient-neovim', {
    "\ 'branch': 'next',
    "\ 'do': 'bash install.sh',
    "\ }
" multi-entry selection UI for LSP
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
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
Plug 'rakr/vim-one'
call plug#end()
if !exists("g:syntax_on")
  syntax enable
endif
filetype plugin indent on

" fb: these take 1s to load so im disabling
"if filereadable("/home/engshare/admin/scripts/vim/fbvim.vim")
  "source /home/engshare/admin/scripts/vim/fbvim.vim
  "source /home/engshare/admin/scripts/vim/biggrep.vim
"endif

"***** REMAPPINGS *****
" solve carpal tunnel
nnoremap ; :
" move visual lines with j,k, but not when using line numbering
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
" save, now that i'm using hhkb layout <C> is easier
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>
" copy to system clipboard
vmap <C-c> :w !pbcopy<CR><CR>
vmap <C-v> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
imap <C-v> <ESC>"*p
map <leader>v :set paste!<CR>
" reselect after shift
vnoremap < <gv
vnoremap > >gv
" don't yank when pasting over something
vnoremap p "_dP

" better tab movement
nmap <silent> <C-n> :tabnext<CR>
nmap <silent> <C-b> :tabprev<CR>
" trailing whitespace
nnoremap <silent> <leader>rtw :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" double esc to clear searchs
nnoremap <esc><esc> :noh<return>
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
" buffer listing with ctrlp <M-p>
nnoremap π :CtrlPBuffer<CR>

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
" disabled while testing COC out
" inoremap <expr> <tab> InsertTabWrapper()
" inoremap <s-tab> <c-n>

" LSP
" Required for operations modifying multiple buffers like rename.
set hidden

"let g:LanguageClient_serverCommands = {
    "\ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    "\ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    "\ 'javascriptreact': ['/usr/local/bin/javascript-typescript-stdio'],
    "\ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    "\ 'python': ['/usr/local/bin/pyls'],
    "\ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    "\ }
    "\ 'typescript': ['/usr/local/bin/javascript-typescript-stdio'],
    "\ 'typescript.tsx': ['/usr/local/bin/javascript-typescript-stdio'],

" note that if you are using Plug mapping you should not use `noremap` mappings.
"nmap <F5> <Plug>(lcn-menu)
"autocmd FileType * call LanguageClientMaps()
"function! LanguageClientMaps()
  "if has_key(g:LanguageClient_serverCommands, &filetype)
    "nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    "nnoremap K :call LanguageClient#textDocument_hover()<CR>
  "endif
"endfunction

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

" autochdir and it's friends don't play well with tmux-resurrect...
set autochdir 				" set cwd to cur buffer's loc
"autocmd BufEnter * silent! lcd %:p:h	" set cwd to cur buffer's loc,
                                        " was for NERDTree but dont need

" holy fuck why have i been in the dark ages
set mouse=a
set undofile
set undodir=~/.vimundo/ " this directory must exist

set ssop-=options	" do not store global/local vars in sessions

set wildignore=*.o,*~,*.pyc " ignore compiled files

" bash style tab completion for files
set wildmode=longest,list,full
set wildmenu

set expandtab      " spaces over tabs
set shiftwidth=2   " soft tabs are 2 spaces for expandtab
set softtabstop=-2 " negative means use shiftwidth
" set noshiftround " do i need this?
" set smarttab     " do i need this?
" real tabs are 4
set tabstop=4

" jump to last position on file open
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\""

"***** FONT AND COLOR *****
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif
if !has("nvim")
  set t_8b=[48;2;%lu;%lu;%lum
  set t_8f=[38;2;%lu;%lu;%lum
endif
colorscheme one
if strftime("%U") < 11
  if strftime("%H") > 9 && strftime("%H") < 18
    set background=light
  else
    set background=dark
  endif
elseif strftime("%U") < 19
  if strftime("%H") > 9 && strftime("%H") < 21
    set background=light
  else
    set background=dark
  endif
elseif strftime("%U") < 33
  if strftime("%H") > 9 && strftime("%H") < 19
    set background=light
  else
    set background=dark
  endif
elseif strftime("%U") < 41
  if strftime("%H") > 9 && strftime("%H") < 18
    set background=light
  else
    set background=dark
  endif
else
  if strftime("%H") > 9 && strftime("%H") < 17
    set background=light
  else
    set background=dark
  endif
endif
let g:one_allow_italics = 1
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
" | as cursor in insert mode instead of block
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

" highlighting and syntax
au! BufRead,BufNewFile *.md   set filetype=markdown	" highlighting for markdown
au! BufRead,BufNewFile *.ejs  set filetype=html		  " highlight for ejs
au! BufRead,BufNewFile *.txt  set filetype=text
au! BufRead,BufNewFile README set filetype=text
set list	"see whitespace"
" set listchars=tab:→\ ,trail:· " the tab arrows are just too ugly
set listchars=tab:\ \ ,trail:·


"***** PLUGIN SETTINGS *****
" ctrlp should also search recent buffers by default
let g:ctrlp_cmd = 'CtrlPMixed'
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
" autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>
" from ziggy
if filereadable("/home/engshare/admin/scripts/vim/fbvim.vim")
  let g:CommandTInputDebounce=50
  let g:CommandTFileScanner='watchman'
  let g:CommandTSmartCase = 1
  let g:CommandTMaxCachedDirectories = 1000
endif
" show indents
let g:indent_guides_enable_on_vim_startup=1
" show vim-javascript's highlighting for flow
let g:javascript_plugin_flow = 1
" ALE for vim8 / nvim
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'javascriptreact': ['prettier'],
\   'json': ['prettier'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\   'typescript': ['prettier', 'eslint'],
\}
let g:ale_fix_on_save = 1
let g:ale_sign_error = '>'
let g:ale_sign_warning = '-'

"****** COC SETTINGS ******
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
