-- References: https://github.com/echasnovski/mini.nvim/blob/main/README.md
-- https://github.com/echasnovski/nvim/blob/master/lua/ec/configs/mini.lua
-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini.txt

require("mini.comment").setup({
	-- Module mappings. Use `''` (empty string) to disable one.
	mappings = {
		-- Toggle comment (like `gcip` - comment inner paragraph) for both
		-- Normal and Visual modes
		comment = "gc",

		-- Toggle comment on current line
		comment_line = "gcc",

		-- Define 'comment' textobject (like `dgc` - delete whole comment block)
		textobject = "gc",
	},
	-- Hook functions to be executed at certain stage of commenting
	hooks = {
		-- Before successful commenting. Does nothing by default.
		pre = function() end,
		-- After successful commenting. Does nothing by default.
		post = function() end,
	},
})
require("mini.pairs").setup({
	-- In which modes mappings from this `config` should be created
	modes = { insert = true, command = true, terminal = true },

	-- Global mappings. Each right hand side should be a pair information, a
	-- table with at least these fields (see more in |MiniPairs.map|):
	-- - <action> - one of 'open', 'close', 'closeopen'.
	-- - <pair> - two character string for pair to be used.
	-- By default pair is not inserted after `\`, quotes are not recognized by
	-- `<CR>`, `'` does not insert pair after a letter.
	-- Only parts of tables can be tweaked (others will use these defaults).
	mappings = {
		["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
		["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
		["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

		[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
		["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
		["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

		['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
		["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
		["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
	},
})

require("mini.surround").setup({
	-- vim-surround style mappings
	-- left brackets add space around the text object
	-- 'ysiw('    foo -> ( foo )
	-- 'ysiw)'    foo ->  (foo)
	custom_surroundings = {
		-- ['('] = { output = { left = '( ', right = ' )' } },
		-- ['['] = { output = { left = '[ ', right = ' ]' } },
		-- ['{'] = { output = { left = '{ ', right = ' }' } },
		-- ['<'] = { output = { left = '< ', right = ' >' } },
		["("] = {
			input = { find = "%(%s-.-%s-%)", extract = "^(.%s*).-(%s*.)$" },
			output = { left = "( ", right = " )" },
		},
		["["] = {
			input = { find = "%[%s-.-%s-%]", extract = "^(.%s*).-(%s*.)$" },
			output = { left = "[ ", right = " ]" },
		},
		["{"] = {
			input = { find = "{%s-.-%s-}", extract = "^(.%s*).-(%s*.)$" },
			output = { left = "{ ", right = " }" },
		},
		["<"] = {
			input = { find = "<%s-.-%s->", extract = "^(.%s*).-(%s*.)$" },
			output = { left = "< ", right = " >" },
		},
		S = {
			-- lua bracketed string mapping
			-- 'ysiwS'  foo -> [[foo]]
			input = { find = "%[%[.-%]%]", extract = "^(..).*(..)$" },
			output = { left = "[[", right = "]]" },
		},
	},
	mappings = {
		add = "ys",
		delete = "ds",
		find = "",
		find_left = "",
		highlight = "gs", -- hijack 'gs' (sleep) for highlight
		replace = "cs",
		update_n_lines = "", -- bind for updating 'config.n_lines'
	},
	-- Number of lines within which surrounding is searched
	n_lines = 62,

	-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
	highlight_duration = 2000,

	-- How to search for surrounding (first inside current line, then inside
	-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
	-- 'cover_or_nearest'. For more details, see `:h MiniSurround.config`.
	search_method = "cover_or_next",
})

-- Remap adding surrounding to Visual mode selection
vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]])

-- unmap config generated `ys` mapping, prevents visual mode yank delay
if vim.keymap then
	vim.keymap.del("x", "ys")
else
	vim.cmd("xunmap ys")
end

-- Make special mapping for "add surrounding for line"
vim.keymap.set("n", "yss", "ys_", { remap = true })

require("mini.indentscope").setup({
	draw = {
		-- Delay (in ms) between event and start of drawing scope indicator
		delay = 100,

		-- Animation rule for scope's first drawing. A function which, given next
		-- and total step numbers, returns wait time (in ms). See
		-- |MiniIndentscope.gen_animation()| for builtin options. To not use
		-- animation, supply `require('mini.indentscope').gen_animation('none')`.
		animation = function(_, _)
			return 5
		end,
	},

	-- Module mappings. Use `''` (empty string) to disable one.
	mappings = {
		-- Textobjects
		object_scope = "ii",
		object_scope_with_border = "ai",

		-- Motions (jump to respective border line; if not present - body line)
		goto_top = "[i",
		goto_bottom = "]i",
	},

	-- Options which control computation of scope. Buffer local values can be
	-- supplied in buffer variable `vim.b.miniindentscope_options`.
	options = {
		-- Type of scope's border: which line(s) with smaller indent to
		-- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
		border = "both",

		-- Whether to use cursor column when computing reference indent. Useful to
		-- see incremental scopes with horizontal cursor movements.
		indent_at_cursor = true,

		-- Whether to first check input line to be a border of adjacent scope.
		-- Use it if you want to place cursor on function header to get scope of
		-- its body.
		try_as_border = true,
	},

	-- Which character to use for drawing scope indicator
	-- alternative styles: ┆ ┊ ╎ │
	symbol = "│",
})

local toggle = function(bufnr)
	if bufnr then
		vim.b.miniindentscope_disable = not vim.b.miniindentscope_disable
	else
		vim.g.miniindentscope_disable = not vim.g.miniindentscope_disable
	end
	require("mini.indentscope").auto_draw({ lazy = true })
end

local btoggle = function()
	toggle(vim.api.nvim_get_current_buf())
end

vim.keymap.set("", '<leader>"', "<cmd>lua require'plugins.indent'.btoggle()<CR>", { silent = true })

return {
	toggle = toggle,
	btoggle = btoggle,
}
