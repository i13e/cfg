"Plug 'reedes/vim-pencil'		    " improved writing experience
"Plug 'tpope/vim-fugitive'		    " git branch in status line
"Plug 'junegunn/fzf.vim'			" fzf integration with vim
"Plug 'machakann/vim-sandwich'		" surround text objects
"Plug 'junegunn/goyo.vim'		    " distraction free writing
"Plug 'junegunn/limelight.vim'		" hyperfocused writing
"Plug 'ap/vim-css-color'			" css colors highlighted
"Plug 'glepnir/dashboard-nvim'

lua << EOF
-- load packer

    -- autorun :PackerCompile whenever plugins.lua is updated
    vim.cmd([[
        augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
        augroup end
        ]])
-- =============================
-- general configuration
-- =============================

-- aliases (NOTE: vim.opt is better than vim.o)
local opt = vim.opt                     -- global
local g   = vim.g                       -- global for let options
local wo  = vim.wo                      -- window local
local bo  = vim.bo                      -- buffer local
local fn  = vim.fn                      -- access vim functions
local cmd = vim.cmd                     -- vim commands
--local map = require('user.utils').map -- import map helper

-- IMPROVE NEOVIM STARTUP
-- https://github.com/editorconfig/editorconfig-vim/issues/50
g.loaded_python_provier=0
g.python3_host_skip_check = 1
g.python3_host_prog='/usr/bin/python'
opt.pyxversion=3


--color configuration
opt.termguicolors = true                -- enable 24-bit RGB colors
cmd [[colorscheme nord]]                -- colorscheme selection

opt.scrolloff = 7                       -- show 7 lines around the cursorline
opt.tabstop = 4                         -- length of a tab
--opt.softtabstop = 4                     -- delete tabs instead of spaces?
opt.expandtab = true                    -- tab uses tabstop length
opt.shiftwidth = 4                      -- level of indentation
opt.hlsearch = false                    -- set highlight on search
wo.number = true                        -- make line numbers default
--vim.wo.relativenumber = true            -- make relative numbers default
opt.hidden = true                       -- allow buffer switching without saving
opt.ignorecase = true                   -- case insensitive searching
opt.smartcase = true                    -- UNLESS /C or capital in search
opt.cursorline = true                   -- show cursor line


opt.showmode = false                    -- disable mode indicator (handled by lualine)

opt.completeopt = "menuone,noselect"    -- options for completion menu

opt.title = true




opt.mouse = 'a'                         -- enable mouse mode
opt.undofile = true                     -- save undo history

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
"set showtabline=1                        " disable tab line
""set guicursor=                         " status bar shows mode; cursor doesn't need to
set clipboard+=unnamedplus              " Enable copy to system clipboard
"set noshowmode                          " disable mode indicator as it is handled by lualine
set spelllang=en_us                     " set language for spell checking
"set completeopt=menu,menuone,noselect   " options for completion menu
""let g:netrw_banner = 0                  " Hide banner shown in the file explorer
""let g:netrw_liststyle = 3               " Use tree view in file explorer
""set encoding=utf-8
"set mouse=a

"undo stuff
let s:undos = split(globpath(&undodir, '*'), "\n")
call filter(s:undos, 'getftime(v:val) < localtime() - (60 * 60 * 24 * 90)')
call map(s:undos, 'delete(v:val)')

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
"nnoremap <leader>ld <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap <leader>la <cmd>lua vim.lsp.buf.code_action()<CR>
"nnoremap <leader>lr <cmd>lua vim.lsp.buf.references()<CR>
"nnoremap <leader>li <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <leader>lh <cmd>lua vim.lsp.buf.hover()<CR>
"nnoremap <leader>ls <cmd>lua vim.lsp.buf.signature_help()<CR>
"nnoremap <leader>lp <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
"nnoremap <leader>ln <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
"nnoremap <leader>tr <cmd>TroubleToggle<cr>

" ==============================
" plugin configuration
" ==============================

" Set nested folding as the default fold style for vim-markdown-folding
"let g:markdown_fold_style = 'nested'

" Configuration for Pencil
"let g:pencil#wrapModeDefault = 'soft'

"augroup pencil
"    autocmd!
"        autocmd FileType markdown,mkd,gmi       call pencil#init()
"        autocmd FileType text                   call pencil#init({'wrap': 'hard'})
"        autocmd FileType markdown,mkd,gmi,text  set spell
"augroup END

" Hide status bar while using fzf commands
"if has('nvim') || has('gui_running')
"  autocmd! FileType fzf
"  autocmd  FileType fzf set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2
"endif



lua require('plugins')
" completion
"lua require'lspconfig'.pyright.setup{}
"local lsp = require "lspconfig"

"lsp.<server>.setup(<stuff...>)                              -- before
"lsp.<server>.setup(coq.lsp_ensure_capabilities(<stuff...>)) -- after

lua << EOF
-- LSP settings
local lspconfig = require 'lspconfig'
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Example custom server
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lspconfig.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
EOF
" Auto-deletes all trailing whitespace and newlines at EOF on save & resets cursor position
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
