" Leader Shortcuts {{{
let mapleader=","
" save session
nnoremap <leader>s :mksession<CR>
" }}}
" Tab settings {{{
set tabstop=4                     " number of visual spaces per TAB
set softtabstop=4                 " number of spaces in tab when editing
set shiftwidth=4                  " number of spaces for displaying code indents
set expandtab                     " tabs are spaces
" }}}
" UI Layout {{{
syntax enable                     " enable syntax
set nocompatible                  " Do not try to be vi
set showcmd                       " show command in bottom bar
set cursorline                    " highlight current line
filetype plugin on                " Enable plugins
filetype indent on                " load filetype-specific indent files
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**
set wildmenu                      " visual autocomplete for command menu
set lazyredraw                    " redraw only when needed
set showmatch                     " highlight matching [{()}]
set termguicolors
" }}}
" Search settings {{{
set incsearch                     " search as characters are entered
set hlsearch                      " highlights matches
" Turn off search highlighting by pressing ,<space>
nnoremap <leader><space> :nohlsearch<CR>
" }}}
" Folding {{{
set foldenable                    " enable folding
set foldlevelstart=10             " open most folds by default
set foldnestmax=10                " 10 nested fold max
set foldmethod=indent             " fold based on indent level
" space open/closes folds
nnoremap <space> za
" }}}
" Modelines {{{
set modeline
set modelines=1
" }}}
" Tagging {{{
" Create the `tags` file
command! MakeTags !ctags -R .
" }}}
" File Browsing {{{
let g:netrw_banner=0              " disable annoying banner
let g:netrw_browse_split=4        " open in prior window
let g:netrw_altv=1                " opens splits to the right
let g:netrw_liststyle=3           " tree view
let g:netrw_winsize=25
nnoremap <leader>fe :Lexplore<CR>
" }}}
" Snippet Injection {{{
" Example Below
" nnoremap <leader>html :-lread $HOME/.vim/.skeleton.html<CR>3jwf>a
" }}}
" Swap Files {{{
set swapfile
set dir=$HOME/tmp
" }}}
" File Extension Overrides {{{
augroup vimrc
  autocmd!
  autocmd BufNewFile,BufRead *.yml setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd BufNewFile,BufRead *.md setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd BufNewFile,BufRead *.js setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END
" }}}
" {{{ Plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'vimwiki/vimwiki'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'othree/yajs.vim'
Plug 'vim-python/python-syntax'

" Themes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'tomasiser/vim-code-dark'

call plug#end()
" }}}
" {{{ Theme
colorscheme codedark
let g:lightline = { 'colorscheme': 'codedark' }
" }}}
" {{{ VimWiki
"
let wiki = {}
let wiki.path = '$WIKI_LOC'
let wiki.auto_tags = 1
let wiki.syntax = 'markdown'
let wiki.ext = '.md'
let wiki.nested_syntaxes = {'py': 'python', 'c++': 'cpp', 'yaml': 'yaml', 'json': 'json', 'js': 'javascript'}
let g:vimwiki_list = [wiki]
let g:vimwiki_global_ext = 0 " Only files in the wiki.path are considered part of vimwiki
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
command! Diary VimwikiDiaryIndex
augroup vimwikigroup
    autocmd!
    " automatically update links on read diary
    autocmd BufRead,BufNewFile diary.md VimwikiDiaryGenerateLinks
augroup end
" }}}
" {{{ nerdcommenter
" <C-_> binds to Ctrl + / for some reason
vmap <C-_> <Plug>NERDCommenterToggle<CR>gv
nmap <C-_> <Plug>NERDCommenterToggle

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code
" indentation
let g:NERDDefaultAlign = 'left'

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check if all selected lines are commented or
" not
let g:NERDToggleCheckAllLines = 1
" }}}
" {{{ gitgutter
" Disable gitgutter automatic mappings
let g:gitgutter_map_keys = 0

" Move to next (]) and previous ([) changes
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" Preview changes
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
" }}}
" vim: set foldmethod=marker foldlevel=0:
