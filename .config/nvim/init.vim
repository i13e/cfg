" load packer
lua require('plugins')

"Plug 'reedes/vim-pencil'		    " improved writing experience
"Plug 'tpope/vim-fugitive'		    " git branch in status line
"Plug 'junegunn/fzf.vim'			" fzf integration with vim
"Plug 'machakann/vim-sandwich'		" surround text objects
"Plug 'junegunn/goyo.vim'		    " distraction free writing
"Plug 'junegunn/limelight.vim'		" hyperfocused writing
"Plug 'ap/vim-css-color'			" css colors highlighted
"Plug 'glepnir/dashboard-nvim'

" ==============================
" general configuration
" ==============================

" color configuration
"set termguicolors                      " enable 24-bit RGB colors
"colorscheme nord                       " color scheme selection

lua << EOF

--color configuration
vim.o.termguicolors = true              --enable 24-bit RGB colors
vim.cmd [[colorscheme nord]]            --colorscheme selection

local set = vim.opt                     --

set.scrolloff = 7                       --show 7 lines around the cursorline
set.tabstop = 4                         --length of a tab
--set.softtabstop = 4                     --?
set.expandtab = true                    --tab uses tabstop length
set.shiftwidth = 4                      --level of indentation
vim.o.hlsearch = false                  --set highlight on search
vim.wo.number = true                    --make line numbers default
--vim.wo.relativenumber = true            --make
set.hidden = true                       --allow buffer switching without saving
vim.o.ignorecase = true                 --case insensitive searching
vim.o.smartcase = true                  --UNLESS /C or capital in search
set.cursorline = true                   --show cursor line






vim.o.mouse = 'a'                       --enable mouse mode
vim.opt.undofile = true                 --Save undo history

EOF

" core configuration                    -
"set scrolloff=7                         " Show 7 lines around the cursorline
"set tabstop=4                           " length of a tab
"set expandtab                           " tab uses tabstop length
"set shiftwidth=4                        " level of indentation
"set number number                       " Enable line numbers
"set hidden                              " allow buffer switching without saving
"set ignorecase                          " ignore case when searching
"set smartcase                           " search for uppercase only when you specify uppercase
"set cursorline                          " show cursor line
set showtabline=1                       " disable tab line
""set guicursor=                         " status bar shows mode; cursor doesn't need to
set clipboard+=unnamedplus              " Enable copy to system clipboard
set noshowmode                          " disable mode indicator as it is handled by lualine
set spelllang=en_us                     " set language for spell checking
set completeopt=menu,menuone,noselect   " options for completion menu
""let g:netrw_banner = 0                  " Hide banner shown in the file explorer
""let g:netrw_liststyle = 3               " Use tree view in file explorer
""set encoding=utf-8
"set mouse=a

"undo stuff
let s:undos = split(globpath(&undodir, '*'), "\n")
call filter(s:undos, 'getftime(v:val) < localtime() - (60 * 60 * 24 * 90)')
call map(s:undos, 'delete(v:val)')

" Neovim python support
lua vim.g.loaded_python_provider = 0
let g:python3_host_prog = '/usr/bin/python'

" ==============================
" keybindings
" ==============================

" set leader key
let mapleader = ","

" switch between buffers quickly
nnoremap <C-n> :bn<cr>
nnoremap <C-p> :bp<cr>

" nvim-tree keybindings
nnoremap <leader>nt	<cmd>NvimTreeToggle<cr>

" lsp bindings
nnoremap <leader>ld <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader>la <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>lr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>li <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>lh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>ls <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>lp <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <leader>ln <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>tr <cmd>TroubleToggle<cr>

" ==============================
" plugin configuration
" ==============================

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

" Hide status bar while using fzf commands
if has('nvim') || has('gui_running')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2
endif



" completion
lua require'lspconfig'.pyright.setup{}
"local lsp = require "lspconfig"
"local coq = require "coq" -- add this

"lsp.<server>.setup(<stuff...>)                              -- before
"lsp.<server>.setup(coq.lsp_ensure_capabilities(<stuff...>)) -- after

lua << EOF
--Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = false,
    --disabled_filetypes={'NvimTree'},
    theme = nord,
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'filename' }, -- { 'branch' }, ?
    -- lualine_c = { 'lsp_progress' },
    lualine_c = {function()
      return require'nvim-treesitter'.statusline(40)
    end},
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}

-- treesitter configuration
require("nvim-treesitter.configs").setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
    }
}
EOF

" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
    autocmd BufWritePre * let currPos = getpos(".")
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePre * %s/\n\+\%$//e
    autocmd BufWritePre *.[ch] %s/\%$/\r/e
    autocmd BufWritePre * cal cursor(currPos[1], currPos[2])
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Update binds when sxhkdrc is updated.
	autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
