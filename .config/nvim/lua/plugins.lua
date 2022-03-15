return require('packer').startup(function()
    -- let packer manage itself
    use 'wbthomason/packer.nvim'

    -- telescope playground for troubleshooting and development
    -- use 'nvim-treesitter/playground'

    -- aesthetics
    use 'shaunsingh/nord.nvim' -- loaded in init.vim
    use {'kyazdani42/nvim-web-devicons', require("nvim-web-devicons").setup()}

    -- completion
    use 'neovim/nvim-lspconfig'

    -- editing
    use {"windwp/nvim-autopairs", config = function() require"nvim-autopairs".setup {} end}

    -- syntax highlighting
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate" } -- config in init.vim

    -- writing
    --use 'reedes/vim-pencil'
    --use 'folke/zen-mode.nvim'
    --use 'folke/twilight.nvim'
    --use 'windwp/nvim-autopairs'

    -- additional ui elements
    use {"kyazdani42/nvim-tree.lua", config = function() require"nvim-tree".setup {} end}
    use {"lewis6991/gitsigns.nvim", config = function() require"gitsigns".setup {} end}
    use "nvim-lualine/lualine.nvim" -- config in init.vim

    -- telescope and dependencies
    -- use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    -- use 'nvim-telescope/telescope.nvim'


    -- autorun :PackerCompile whenever plugins.lua is updated
    vim.cmd([[
        augroup packer_user_config
            autocmd!
            autocmd BufWritePost plugins.lua source <afile> | PackerCompile
        augroup end
    ]])
    --Core/dependencies: file type handler, plugin manager, global dependencies for other plugins...

--UI: sidebar, nav tree, tab list, colorscheme...

--LSP: lsp-config, lang servers.

--Tools: completion, motions, snippets.

--Debug: DAP.

--Utils: auto saving, smooth scrolling, commenting, undo tree, highlighting.

--Extensions: extra file types, tools for programming languages, ...

















end)


