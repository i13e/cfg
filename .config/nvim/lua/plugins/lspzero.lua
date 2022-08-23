require("mason.settings").set({
	max_concurrent_installers = 10,
	-- log_level = vim.log.levels.TRACE,
	ui = {
		border = "rounded",
		icons = {
			package_installed = "",
			package_pending = "",
			package_uninstalled = "",
		},
	},
})

local lsp = require("lsp-zero")
local cmp = require("cmp")

-- lsp.ensure_installed({
-- 	"html",
-- 	"cssls",
-- 	"tsserver",
-- 	"sumneko_lua",
-- })

lsp.set_preferences({
	suggest_lsp_servers = true,
	setup_servers_on_start = true,
	set_lsp_keymaps = true,
	configure_diagnostics = true,
	-- cmp_capabilities = true,
	manage_nvim_cmp = true,
	call_servers = "local",
	sign_icons = {
		error = "", -- 
		warn = "", -- 
		hint = "",
		info = "", --  
	},
})

local icons = {
	Text = "", -- 
	Method = "",
	Function = "",
	Constructor = "", -- 
	Field = "", --  
	Variable = "", --   
	Class = "", --   ﴯ  
	Interface = "", --  ﰮ
	Module = "",
	Property = "",
	Unit = "ﰩ", --       塞
	Value = "",
	Enum = "", -- ﬧ   練
	EnumMember = "",
	Keyword = "", -- 
	Snippet = "﬌", --  
	Color = "", --   
	File = "",
	Folder = "",
	Reference = "", --  
	Constant = "", -- ﱃ 洞     π
	Struct = "פּ", -- 
	Event = "",
	Operator = "璉", -- 
	TypeParameter = "",
	Copilot = "", -- copilot
}

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#B48EAD" })

lsp.setup_nvim_cmp({
	formatting = {
		-- changing the order of fields so the icon is the first
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local source_names = {
				buffer = "Buffer",
				cmdline = "Cmdline",
				copilot = "Copilot",
				luasnip = "Snippet",
				nvim_lsp = "LSP",
				nvim_lua = "API",
				path = "Path",
			}

			vim_item.menu = ("%-10s [%s]"):format(vim_item.kind, source_names[entry.source.name] or entry.source.name)

			vim_item.kind = string.format("%s", icons[vim_item.kind])

			return vim_item
		end,
	},
	completion = {
		-- start completion immediately
		keyword_length = 1,
		-- border = "single",
	},
	--sources = cmp_sources,
	sources = {
		{ name = "copilot" },
		-- other sources
		{ name = "nvim_lsp" },
		-- { name = "spell" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
	},
	documentation = {
		max_height = 15,
		max_width = 60,
		border = "rounded",
		winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
		zindex = 1001,
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

lsp.nvim_workspace()
lsp.setup()
