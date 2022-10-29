-- References: https://github.com/echasnovski/mini.nvim/blob/main/README.md
-- https://github.com/echasnovski/nvim/blob/master/lua/ec/configs/mini.lua
-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini.txt

-- require("mini.sessions").setup({ directory = "~/.config/nvim/misc/sessions" })
require("mini.starter").setup()

vim.api.nvim_exec(
	[[hi default MiniCursorWord cterm=underline gui=underline
      hi default link MiniCursorwordCurrent MiniCursorWord]],
	true
)
vim.schedule(function()
	-- require('mini.ai').setup({
	--   custom_textobjects = {
	--     F = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
	--   },
	-- })
	require("mini.align").setup()
	-- require('mini.bufremove').setup()
	require("mini.comment").setup()
	-- require('mini.completion').setup({
	--   lsp_completion = {
	--     source_func = 'omnifunc',
	--     auto_setup = false,
	--     process_items = function(items, base)
	--       -- Don't show 'Text' and 'Snippet' suggestions
	--       items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
	--       return MiniCompletion.default_process_items(items, base)
	--     end,
	--   },
	-- })
	require("mini.cursorword").setup()
	-- require('mini.indentscope').setup()
	require("mini.jump").setup()
	-- require('mini.jump2d').setup()

	-- require('mini.misc').setup()
	require("mini.pairs").setup({ modes = { insert = true, command = true, terminal = true } })
	-- require('mini.surround').setup({ search_method = 'cover_or_next' })
	-- require('mini.test').setup()
	require("mini.trailspace").setup()
end)

require("mini.surround").setup({
	-- vim-surround style mappings
	-- left brackets add space around the text object
	-- 'ysiw('    foo -> ( foo )
	-- 'ysiw)'    foo ->  (foo)
	custom_surroundings = {
		S = {
			-- lua bracketed string mapping
			-- 'ysiwS'  foo -> [[foo]]
			input = { "%[%[().-()%]%]" },
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

vim.keymap.set(
	"",
	'<leader>"',
	"<cmd>lua require'plugins.indent'.btoggle()<CR>",
	{ silent = true, desc = "toggle 'mini.indentscope' on/off" }
)

return {
	toggle = toggle,
	btoggle = btoggle,
}
