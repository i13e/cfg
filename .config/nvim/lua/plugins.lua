local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local ok, packer = pcall(require, "packer")
if not ok then
	return
end

-- Enable profiling and have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
	profile = {
		enable = true,
	},
})

-- Install plugins
return packer.startup(function(use)
	-- speed up 'require', must be the first plugin
	use("lewis6991/impatient.nvim")

	-- Packer can manage itself as an optional plugin
	use("wbthomason/packer.nvim")

	-- Common dependency for Lua plugins
	use({ "nvim-lua/plenary.nvim", event = "VimEnter" })

	-- Colorful icons
	use({ "kyazdani42/nvim-web-devicons", event = "VimEnter" })

	-- Analyze startuptime
	use({ "dstein64/vim-startuptime", cmd = "StartupTime" })

	-- Collection of minimal and fast Lua modules
	use("echasnovski/mini.nvim")

	-- needs no introduction
	use({ "tpope/vim-fugitive", event = "VimEnter" })

	-- Add git related info in the signs columns and popups
	use("lewis6991/gitsigns.nvim")

	-- smooth scrolling
	use("karb94/neoscroll.nvim")
	-- use({
	-- 	"gen740/SmoothCursor.nvim",
	-- 	config = function()
	-- 		require("smoothcursor").setup()
	-- 	end,
	-- })

	--use("tpope/vim-repeat")
	--use("tpope/vim-sleuth")
	--use("justinmk/vim-dirvish")
	--use("christoomey/vim-tmux-navigator")
	--use("j-hui/fidget.nvim")

	-- use("bfredl/nvim-luadev")
	-- use("ziglang/zig.vim")

	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			-- "onsails/lspkind.nvim",
			-- "glepnir/lspsaga.nvim",

			-- Autocompletion
			{
				"hrsh7th/nvim-cmp",
				requires = {
					-- "f3fora/cmp-spell",
					"hrsh7th/cmp-buffer",
					"hrsh7th/cmp-cmdline",
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-nvim-lua",
					"hrsh7th/cmp-path",
					-- "hrsh7th/cmp-nvim-lsp-document-symbol"
					-- "hrsh7th/cmp-nvim-lsp-signature-help",
					-- "octaltree/cmp-look",
					-- "ray-x/cmp-treesitter",
					"saadparwaiz1/cmp_luasnip",
					-- "tamago324/cmp-zsh",
					{
						"zbirenbaum/copilot.lua",
						config = function()
							require("copilot").setup()
						end,
					},
					{
						"zbirenbaum/copilot-cmp",
						-- after = { "copilot.lua" },
						config = function()
							require("copilot_cmp").setup()
						end,
					},
				},
			},

			-- Snippets
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
	})

	-- nvim-treesitter
	-- verify a compiler exists before installing
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/playground",
		},
	})

	-- File tree explorer
	use({ "kyazdani42/nvim-tree.lua", cmd = { "NvimTreeToggle", "NvimTreeFindFile" } })

	-- use({
	--     "nvim-neo-tree/neo-tree.nvim",
	--     branch = "v2.x",
	--     requires = {
	--         "nvim-lua/plenary.nvim",
	--         "kyazdani42/nvim-web-devicons",
	--         "MunifTanjim/nui.nvim",
	--     },
	--     config = function()
	--         require("wb.neo-tree").setup()
	--     end,
	-- })

	-- Terminal and REPLs
	use({
		"akinsho/toggleterm.nvim",
		-- keys = { "gxx", "gx", "<C-\\>" },
		-- cmd = { "T" },
	})

	-- Fuzzy finder
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-telescope/telescope-fzy-native.nvim",
		},
		opt = true,
	})

	-- only required if you do not have fzf binary
	-- use = { 'junegunn/fzf', run = './install --bin', }
	use({
		"ibhagwan/fzf-lua",
		opt = true,
	})

	-- better quickfix
	use({ "kevinhwang91/nvim-bqf" })

	-- Code linting & formatting
	use({
		"jose-elias-alvarez/null-ls.nvim",
		after = { "nvim-lspconfig" },
		event = "VimEnter",
	})

	-- Debug Adapter Protocol
	use({
		"mfussenegger/nvim-dap",
		requires = {
			"mfussenegger/nvim-dap-python",
			"rcarriga/nvim-dap-ui",
			"jbyuki/one-small-step-for-vimkind",
		},
		keys = { "<F5>", "<F8>", "<F9>" },
	})

	-- Show keybindings
	use({ "folke/which-key.nvim", event = "VimEnter" })

	-- Colorscheme
	use("shaunsingh/nord.nvim")

	-- Colorizer
	-- use({
	-- 	"nvchad/nvim-colorizer.lua",
	-- 	config = require("colorizer").setup(),
	-- 	-- cmd = { "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer" },
	-- 	opt = true,
	-- })

	-- Statusline
	use({
		"nvim-lualine/lualine.nvim",
		config = require("lualine").setup(),
	})

	-- bufferline
	use("akinsho/bufferline.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
