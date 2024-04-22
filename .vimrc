"" Custom Functions
function TexCompile()
:w
!pdflatex %
endfunction

"" Custom latex functions using vim-surround
"" shift+s, b to make BOLD text
let g:surround_102 = "\textbf{\r}"

"" Custom Commands
:set colorcolumn=80
:set wrap
:set tw=80
:set number

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" switch between buffers
nnoremap <C-Tab> :bn<CR>
nnoremap <C-S-Tab> :bp<CR>

call plug#begin('~/.vim/plugged')
" Need vim-plug for this https://github.com/junegunn/vim-plug
" Make sure you use single quotes

" Theme
Plug 'drewtempelmeyer/palenight.vim'

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'preservim/nerdtree'
" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'rsaraf/vim-advanced-lint'
" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
" Plugin outside /.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '/.fzf', 'do': './install --all' }
Plug 'tpope/vim-surround'
Plug 'https://github.com/joshdick/onedark.vim'
" Plug 'lervag/vimtex'
" Snippets and so on require pip install pynvim
" Plug 'ycm-core/YouCompleteMe'
" Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them
" Maybe you need to symlink in order to make sure the dirs are talking
" ln -s ~/.vim/plugged/vim-snippets/UltiSnips ~/.config/nvim/UltiSnips
" Plug 'honza/vim-snippets'
Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'franbach/miramare'
"Plug 'sheerun/vim-polyglot'
Plug 'https://github.com/Mizux/vim-colorschemes'
Plug 'https://github.com/tjammer/focusedpanic.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bhurlow/vim-parinfer'
Plug 'https://github.com/Glench/Vim-Jinja2-Syntax'
" Initialize plugin system
call plug#end()

" Shortcuts
map <C-n> :NERDTreeToggle<CR>

"TRUE COLORS
if (has("nvim"))
"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (guicolors option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
set termguicolors
endif

set number      " show line numbers
set tabstop=4   " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab   " expand tabs to spaces

" indent when moving to the next line while writing code
set autoindent

" when using the >> or << commands, shift lines by 4 spaces
"set shiftwidth=4

"" show a visual line under the cursor's current line
"" set cursorline

"" show the matching part of the pair for [] {} and ()
set showmatch

"" enable all Python syntax highlighting features
let python_highlight_all = 1

"" Snippets
"let g:UltiSnipsExpandTrigger = "<tab>"
"let g:UltiSnipsJumpForwardTrigger = "<c-j>"
"let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
"let g:UltiSnipsEnableSnipMate = 0

"" important!!
set termguicolors

"" the configuration options should be placed before colorscheme miramare
"let g:miramare_enable_italic = 1
"let g:miramare_disable_italic_comment = 1

colorscheme miramare

"set guifont=Inconsolata\ for\ Powerline:h15
"let g:Powerline_symbols = 'fancy'
"set encoding=utf-8
"set t_Co=256
"set fillchars+=stl:\ ,stlnc:

"set term=xterm-256color
"set termencoding=utf-8

if has("gui_running")
let s:uname = system("uname")
if s:uname == "Darwin\n"
set guifont=Inconsolata\ for\ Powerline:h15
endif
endif

" colorscheme onedark
" Disable auto indent
" filetype indent off
" set guifont=Roboto_Mono:h13
set guifont=Jetbrains_Mono:h11
