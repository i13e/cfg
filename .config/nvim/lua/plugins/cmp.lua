local res, cmp = pcall(require, "cmp")
if not res then
	return
end

local res_luasnip, luasnip = pcall(require, "luasnip")
if not res_luasnip then
	return
end

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		-- must use a snippet engine
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	window = {
		--completion = { border = 'single' },
		documentation = {
			--border = 'single',
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
	},

	completion = {
		-- start completion immediately
		keyword_length = 1,
	},
	sources = {
		-- copilot source
		{ name = "copilot" },
		-- other sources
		{ name = "nvim_lsp" },
		-- { name = "spell" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
	},

	mapping = {
		["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i" }),
		["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i" }),
		["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
		["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
		["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
		["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
		["<S-up>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<S-down>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<C-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
		["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }),
	},

	formatting = {
		deprecated = false,
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

			-- get the item kind icon from our LSP settings
			local kind_idx = vim.lsp.protocol.CompletionItemKind[vim_item.kind]
			if tonumber(kind_idx) > 0 then
				vim_item.kind = vim.lsp.protocol.CompletionItemKind[kind_idx]
			end

			if entry.source.name == "copilot" then
				vim_item.kind = " "
				return vim_item
			end

			return vim_item
		end,
	},

	sorting = {
		priority_weight = 2,
		comparators = {
			require("copilot_cmp.comparators").prioritize,
			require("copilot_cmp.comparators").score,

			-- Below is the default comparitor list and order for nvim-cmp
			cmp.config.compare.offset,
			-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},

	-- DO NOT ENABLE
	-- just for testing with nvim native completion menu
	experimental = {
		native_menu = false,
		ghost_text = true,
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
