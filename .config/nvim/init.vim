" ====================================================================
" 			Vim-Plug Settings
" ====================================================================

" Initialize vim-plug
" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" Plugins
Plug 'arcticicestudio/nord-vim'		" color scheme
Plug 'reedes/vim-pencil'		" improved writing experience
Plug 'itchyny/lightline.vim'		" status bar
"Plug 'tpope/vim-fugitive'		" git branch in status line
Plug 'mgee/lightline-bufferline'	" buffers in tabline
Plug 'junegunn/fzf.vim'			" fzf integration with vim
Plug 'machakann/vim-sandwich'		" surround text objects
Plug 'junegunn/goyo.vim'		" distraction free writing
Plug 'junegunn/limelight.vim'		" hyperfocused writing
Plug 'ap/vim-css-color'			" css colors highlighted
Plug 'glepnir/dashboard-nvim'
Plug 'ryanoasis/vim-devicons'
" Finish initialization of vim-plug
call plug#end()

" ====================================================================
" 			Vim Color Configuration
" ====================================================================
set termguicolors
let g:nord_italic = 1			" enable italics
let g:nord_underline = 1		" enable underlining
colorscheme nord			" color scheme selection
hi Normal guibg=NONE ctermbg=NONE
" ====================================================================
" 			Vim Core Configuration
" ====================================================================
set scrolloff=7				" Show 7 lines around the cursorline
let g:netrw_banner = 0			" Hide banner shown in the file explorer
let g:netrw_liststyle = 3		" Use tree view in file explorer
set encoding=utf-8
set number number			" Enable line numbers
set hidden  				" allow buffer switching without saving
set cursorline				" Show cursor line
set mouse=a
set showtabline =2			" Show tabline always
set clipboard+=unnamedplus		" Enable copy to system clipboard

" ====================================================================
" 			     Keybindings
" ====================================================================

" Define my leader key
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
let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd,vimwiki call pencil#init()
 autocmd FileType text         call pencil#init({'wrap': 'hard'})
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
let g:dashboard_custom_header = [
            \ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
            \ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
            \ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
            \ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
            \ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
            \ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
            \]

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
