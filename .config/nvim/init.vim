" load packer
lua require('plugins')

" autorun :PackerCompile whenever plugins.lua is updated
augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
" ====================================================================
" 			Vim-Plug Settings
" ====================================================================

" Initialize vim-plug
" Specify a directory for plugins
"call plug#begin('~/.local/share/nvim/plugged')
"Plug 'arcticicestudio/nord-vim'		" color scheme
"Plug 'reedes/vim-pencil'		" improved writing experience
"Plug 'itchyny/lightline.vim'		" status bar
"Plug 'tpope/vim-fugitive'		" git branch in status line
"Plug 'mgee/lightline-bufferline'	" buffers in tabline
"Plug 'junegunn/fzf.vim'			" fzf integration with vim
"Plug 'machakann/vim-sandwich'		" surround text objects
"Plug 'junegunn/goyo.vim'		" distraction free writing
"Plug 'junegunn/limelight.vim'		" hyperfocused writing
"Plug 'ap/vim-css-color'			" css colors highlighted
"Plug 'glepnir/dashboard-nvim'
"Plug 'ryanoasis/vim-devicons'
"call plug#end()

" color configuration
set termguicolors                       " enable 24-bit RGB colors
colorscheme nord                        " color scheme selection

" core configuration
set scrolloff=7		    		        " Show 7 lines around the cursorline
set tabstop=4	    			        " length of a tab
set expandtab                           " tab uses tabstop length
set shiftwidth=4                        " level of indentation
set number number			            " Enable line numbers
set hidden  				            " allow buffer switching without saving
set ignorecase				            " ignore case when searching
set smartcase			    	        " search for uppercase only when you specify uppercase
set cursorline		    		        " show cursor line
set showtabline=2   			        " disable tab line
"set guicursor=                          " status bar shows mode; cursor doesn't need to
set clipboard+=unnamedplus		        " Enable copy to system clipboard
"set noshowmode                          " disable mode indicator as it is handled by lualine
set spelllang=en_us                     " set language for spell checking
set completeopt=menu,menuone,noselect   " options for completion menu
""let g:netrw_banner = 0                  " Hide banner shown in the file explorer
""let g:netrw_liststyle = 3		          " Use tree view in file explorer
""set encoding=utf-8
set mouse=a

" python
let g:loaded_python_provider = 0
let g:python3_host_prog = '/usr/bin/python'

" keybindings

" set leader key
let mapleader = ","

" Trigger FZF's search lines from all buffers
nnoremap <C-F> :Lines<CR>

" Switch between buffers quickly
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>

" ====================================================================
" 			Plugin Configuration
" ====================================================================

" Set nested folding as the default fold style for vim-markdown-folding
let g:markdown_fold_style = 'nested'

" Configuration for Pencil
let g:pencil#wrapModeDefault = 'soft'

augroup pencil
    autocmd!
        autocmd FileType markdown,mkd,gmi       call pencil#init()
        autocmd FileType text                   call pencil#init({'wrap': 'hard'})
        autocmd FileType markdown,mkd,gmi,text  set spell
augroup END

" Lightline
set noshowmode 				" Hide mode because Lightline handles it
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ }
      \ }

" Integrate lightline-bufferline with lightline
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}

" Hide status bar while using fzf commands
if has('nvim') || has('gui_running')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2
endif

" Automatically deletes all trailing whitespace on save.
	autocmd BufWritePre * %s/\s\+$//e
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
" Update binds when sxhkdrc is updated.
	autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
" Reload zsh when config files are updated
	"autocmd BufWritePost *zsh !exec zsh
" Dashboard options
"let g:dashboard_custom_header = [
"            \ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
"            \ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
"            \ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
"            \ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
"            \ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
"            \ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
"            \]

let g:mapleader="\<Space>"
let g:dashboard_default_executive ='fzf'
nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
nnoremap <silent> <Leader>fr :DashboardFindHistory<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>cc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>fw :DashboardFindWord<CR>
nnoremap <silent> <Leader>jb :DashboardJumpMark<CR>
nnoremap <silent> <Leader>cn :DashboardNewFile<CR>
