"" Custom Functions
function TexCompile()
  :w
  !pdflatex %
endfunction

"" Custom latex functions using vim-surround
"" shift+s, b to make BOLD text
let g:surround_102 = "\\textbf{\r}"

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
" swtich between buffers
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
" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
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
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

set number      " show line numbers
set ts=2        " set tabs to have 4 spaces

" indent when moving to the next line while writing code
"set autoindent

" expand tabs into spaces
"set expandtab

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

"" the configuration options should be placed before `colorscheme miramare`
"let g:miramare_enable_italic = 1
"let g:miramare_disable_italic_comment = 1

colorscheme miramare

"set guifont=Inconsolata\ for\ Powerline:h15
"let g:Powerline_symbols = 'fancy'
"set encoding=utf-8
"set t_Co=256
"set fillchars+=stl:\ ,stlnc:\
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
set guifont=Jetbrains_Mono:h13


"------------------------------------------------------------------------------
" slime configuration
"------------------------------------------------------------------------------
" always use tmux
let g:slime_target = 'vimterminal'

" fix paste issues in ipython
let g:slime_python_ipython = 1

" always send text to the top-right pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{top-right}' }
let g:slime_dont_ask_default = 1

"------------------------------------------------------------------------------
" ipython-cell configuration
"------------------------------------------------------------------------------
" Keyboard mappings. <Leader> is \ (backslash) by default

" map <Leader>s to start IPython
nnoremap <Leader>s :SlimeSend1 ipython --matplotlib<CR>

" map <Leader>r to run script
nnoremap <Leader>r :IPythonCellRun<CR>

" map <Leader>R to run script and time the execution
nnoremap <Leader>R :IPythonCellRunTime<CR>

" map <Leader>c to execute the current cell
nnoremap <Leader>c :IPythonCellExecuteCell<CR>

" map <Leader>C to execute the current cell and jump to the next cell
nnoremap <Leader>C :IPythonCellExecuteCellJump<CR>

" map <Leader>l to clear IPython screen
nnoremap <Leader>l :IPythonCellClear<CR>

" map <Leader>x to close all Matplotlib figure windows
nnoremap <Leader>x :IPythonCellClose<CR>

" map [c and ]c to jump to the previous and next cell header
nnoremap [c :IPythonCellPrevCell<CR>
nnoremap ]c :IPythonCellNextCell<CR>

" map <Leader>h to send the current line or current selection to IPython
nmap <Leader>h <Plug>SlimeLineSend
xmap <Leader>h <Plug>SlimeRegionSend

" map <Leader>p to run the previous command
nnoremap <Leader>p :IPythonCellPrevCommand<CR>

" map <Leader>Q to restart ipython
nnoremap <Leader>Q :IPythonCellRestart<CR>

" map <Leader>d to start debug mode
nnoremap <Leader>d :SlimeSend1 %debug<CR>

" map <Leader>q to exit debug mode or IPython
nnoremap <Leader>q :SlimeSend1 exit<CR>

" map <F9> and <F10> to insert a cell header tag above/below and enter insert mode
nmap <F9> :IPythonCellInsertAbove<CR>a
nmap <F10> :IPythonCellInsertBelow<CR>a

" also make <F9> and <F10> work in insert mode
imap <F9> <C-o>:IPythonCellInsertAbove<CR>
imap <F10> <C-o>:IPythonCellInsertBelow<CR>
