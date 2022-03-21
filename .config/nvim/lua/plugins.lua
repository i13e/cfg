return require('packer').startup(function(use)
    -- let packer manage itself

    -- telescope playground for troubleshooting and development
    -- use 'nvim-treesitter/playground'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'
    -- aesthetics

    -- completion

    -- editing
    use {'windwp/nvim-autopairs', require'nvim-autopairs'.setup()}

    -- syntax highlighting

    -- writing
    --use 'reedes/vim-pencil'
    --use 'folke/zen-mode.nvim'
    --use 'folke/twilight.nvim'

    -- additional ui elements
    use {'lewis6991/gitsigns.nvim',requires = {'nvim-lua/plenary.nvim'},
        require('gitsigns').setup {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '[c', require"gitsigns".prev_hunk, {buffer=bufnr})
                vim.keymap.set('n', ']c', require"gitsigns".next_hunk, {buffer=bufnr})
            end
        }
    }

    -- set statusbar
    use {'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        require('lualine').setup {
            options = {
                icons_enabled = true,
                --disabled_filetypes={'NvimTree'},
                theme = 'auto',
                component_separators = '|',
                section_separators = '',
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'filename', 'branch' },
                -- lualine_c = { 'lsp_progress' },
                lualine_c = {function()
                    return require'nvim-treesitter'.statusline(40)
                end},
                lualine_x = { 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' },
            },
        }
    }
    -- telescope and dependencies
    -- use 'nvim-lua/popup.nvim'


    --Core/dependencies: file type handler, plugin manager, global dependencies for other plugins...
    use 'wbthomason/packer.nvim'
    --UI: sidebar, nav tree, tab list, colorscheme...
    use 'shaunsingh/nord.nvim'
    use {'kyazdani42/nvim-tree.lua', requires = {'kyazdani42/nvim-web-devicons'},
        require('nvim-tree').setup() }

    --LSP: lsp-config, lang servers.
    use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp'

    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip' -- Snippets plugin

    --Tools: completion, motions, snippets.
    --Debug: DAP.

    --Utils: auto saving, smooth scrolling, commenting, undo tree, highlighting.
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
        require('nvim-treesitter.configs').setup {
            highlight = {
                enable = true, -- false will disable the whole extension
            },
            incremental_selection = {
                enable = true,
                --disable = { 'org' }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
                --additional_vim_regex_highlighting = { 'org' }, -- Required since TS highlighter doesn't support all syntax features (conceal)
                keymaps = {
                    init_selection = 'gnn',
                    node_incremental = 'grn',
                    scope_incremental = 'grc',
                    node_decremental = 'grm',
                },
            },
            indent = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']m'] = '@function.outer',
                        [']]'] = '@class.outer',
                    },
                    goto_next_end = {
                        [']M'] = '@function.outer',
                        [']['] = '@class.outer',
                    },
                    goto_previous_start = {
                        ['[m'] = '@function.outer',
                        ['[['] = '@class.outer',
                    },
                    goto_previous_end = {
                        ['[M'] = '@function.outer',
                        ['[]'] = '@class.outer',
                    },
                },
            },
        }
    }

    use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'},
        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                    },
                },
            },
        }
    }
    --Extensions: extra file types, tools for programming languages, ...

















end)
