local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- Automatically install packer
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

vim.cmd([[packadd packer.nvim]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
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
		threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
	},
})

-- Install plugins
return packer.startup(function(use)
	local config = function(name)
		return string.format("require('plugins.%s')", name)
	end

	local use_with_config = function(path, name)
		use({ path, config = config(name) })
	end

	-- speed up 'require', must be the first plugin
	use("lewis6991/impatient.nvim")

	-- Packer can manage itself as an optional plugin
	use("wbthomason/packer.nvim")

	-- Analyze startuptime
	use({ "dstein64/vim-startuptime", cmd = "StartupTime" })

	-- plenary is required by gitsigns and telescope
	-- lazy load so gitsigns doesn't abuse our startup time
	use({ "nvim-lua/plenary.nvim", event = "VimEnter" })

	-- optional for fzf-lua, telescope, nvim-tree
	use({ "kyazdani42/nvim-web-devicons", event = "VimEnter" })

	use({
		"zbirenbaum/copilot.lua",
		event = "VimEnter",
		config = function()
			vim.defer_fn(function()
				require("copilot").setup()
			end, 100)
		end,
	})
	-- mini vim plugin collection
	use({
		"echasnovski/mini.nvim",
		config = config("mini"),
		event = "VimEnter",
	})

	-- needs no introduction
	use({ "tpope/vim-fugitive", config = config("fugitive"), event = "VimEnter" })

	-- Add git related info in the signs columns and popups
	use_with_config("lewis6991/gitsigns.nvim", "gitsigns")

	-- use({
	-- 	"karb94/neoscroll.nvim",
	-- 	opt = true,
	-- 	event = "WinScrolled",
	-- 	keys = {
	-- 		"<C-u>",
	-- 		"<C-d>", -- '<C-b>', '<C-f>',
	-- 		"<C-y>",
	-- 		"<C-e>",
	-- 		"zt",
	-- 		"zz",
	-- 		"zb",
	-- 	},
	-- 	config = config("neoscroll"),
	-- })

	--use("tpope/vim-repeat")
	--use("tpope/vim-sleuth")
	--use("justinmk/vim-dirvish")
	--use("christoomey/vim-tmux-navigator")
	--use("j-hui/fidget.nvim")

	use("bfredl/nvim-luadev") -- FIXME
	use("ziglang/zig.vim")

	use({
		"VonHeikemen/lsp-zero.nvim",
		config = config("lspzero"),
		after = "copilot.lua",
		requires = {
			-- LSP Support
			"neovim/nvim-lspconfig",
			-- "onsails/lspkind.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Autocompletion
			{
				"hrsh7th/nvim-cmp",
				requires = {
					-- "f3fora/cmp-spell",
					"hrsh7th/cmp-buffer",
					"hrsh7th/cmp-cmdline",
					"hrsh7th/cmp-nvim-lsp",
					-- "hrsh7th/cmp-nvim-lsp-document-symbol"
					-- "hrsh7th/cmp-nvim-lsp-signature-help",
					"hrsh7th/cmp-nvim-lua",
					"hrsh7th/cmp-path",
					-- "octaltree/cmp-look",
					-- "ray-x/cmp-treesitter",
					"saadparwaiz1/cmp_luasnip",
					-- "tamago324/cmp-zsh"
					"zbirenbaum/copilot-cmp",
				},
			},

			-- Snippets
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
	})

	-- nvim-treesitter
	-- verify a compiler exists before installing
	--if require("utils").have_compiler() then
	use({
		"nvim-treesitter/nvim-treesitter",
		config = config("treesitter"),
		run = ":TSUpdate",
		--event = "BufRead",
	})
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = { "nvim-treesitter" },
	})
	-- debugging treesitter
	use({
		"nvim-treesitter/playground",
		after = { "nvim-treesitter" },
		cmd = { "TSPlaygroundToggle" },
	})
	--end

	-- nvim-tree
	use({ "kyazdani42/nvim-tree.lua", config = config("nvim-tree"), cmd = { "NvimTreeToggle", "NvimTreeFindFile" } })

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

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			-- { "nvim-lua/popup.nvim" },
			{ "nvim-telescope/telescope-fzy-native.nvim" },
		},
		setup = config("telescope.mappings"),
		config = config("telescope"),
		opt = true,
	})

	-- only required if you do not have fzf binary
	-- use = { 'junegunn/fzf', run = './install --bin', }
	use({
		"ibhagwan/fzf-lua",
		setup = config("fzf-lua.mappings"),
		config = config("fzf-lua"),
		opt = true,
	})

	-- better quickfix
	use({ "kevinhwang91/nvim-bqf", config = config("bqf"), ft = { "qf" } })

	-- Code linting and formatting
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = config("null-ls"),
		after = { "lsp-zero" },
		event = "VimEnter",
	})

	-- Debug Adapter Protocol
	use({
		{
			"mfussenegger/nvim-dap",
			config = config("dap"),
			keys = { "<F5>", "<F8>", "<F9>" },
		},
		{ "rcarriga/nvim-dap-ui", config = config("dap.ui"), after = { "nvim-dap" } },
		{ "jbyuki/one-small-step-for-vimkind", after = { "nvim-dap" } },
	})

	-- key bindings cheatsheet
	use({
		"folke/which-key.nvim",
		event = "VimEnter",
		config = config("which_key"),
	})

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

	-- Dashboard (start screen)
	-- use_with_config("goolord/alpha-nvim", "alpha-nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
