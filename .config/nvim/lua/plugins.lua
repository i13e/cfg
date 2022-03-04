return require('packer').startup(function()
  -- let packer manage itself
  use 'wbthomason/packer.nvim'

  -- telescope playground for troubleshooting and development
  -- use 'nvim-treesitter/playground'

  -- aesthetics
  use 'shaunsingh/nord.nvim'
  -- use 'kyazdani42/nvim-web-devicons'

-- completion
    use 'neovim/nvim-lspconfig'
  -- syntax highlighting
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- writing
--use 'reedes/vim-pencil'
--use 'folke/zen-mode.nvim'
--use 'folke/twilight.nvim'
--use 'windwp/nvim-autopairs'

  -- additional ui elements
  -- use 'shadmansaleh/lualine.nvim'
  -- use 'lewis6991/gitsigns.nvim'
  -- use 'kyazdani42/nvim-tree.lua'

  -- telescope and dependencies
  -- use 'nvim-lua/popup.nvim'
  -- use 'nvim-lua/plenary.nvim'
  -- use 'nvim-telescope/telescope.nvim'

  end)
