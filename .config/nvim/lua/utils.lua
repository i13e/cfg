-- https://github.com/ibhagwan/nvim-lua/blob/main/lua/utils.lua
local fn = vim.fn -- access vim functions

-- function _G.reload(package)
-- 	package.loaded[package] = nil
-- 	return require(package)
-- end

local M = {}

-- https://neovim.discourse.group/t/reload-init-lua-and-all-require-d-scripts/971/11
M.ReloadConfig = function()
	local hls_status = vim.v.hlsearch
	for name, _ in pairs(package.loaded) do
		if name:match("^cnull") then
			package.loaded[name] = nil
		end
		dofile(vim.env.MYVIMRC)
	end
	dofile(vim.env.MYVIMRC)
	if hls_status == 0 then
		vim.opt.hlsearch = false
	else
		vim.opt.hlsearch = true
	end
end

-- Make sure user modules can be reloaded when using :source
-- source: https://www.reddit.com/r/neovim/comments/vihqql/comment/idf7b2j
M.load = function(mod)
	package.loaded[mod] = nil
	require(mod)
end

-- https://blog.devgenius.io/create-custom-keymaps-in-neovim-with-lua-d1167de0f2c2
-- https://oroques.dev/notes/neovim-init/
M.map = function(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

M.toggle_quicklist = function()
	if fn.empty(fn.filter(fn.getwininfo(), "v:val.quickfix")) == 1 then
		vim.cmd("copen")
	else
		vim.cmd("cclose")
	end
end

M.blockwise_clipboard = function()
	vim.cmd("call setreg('+', @+, 'b')")
	-- print("set + reg: blockwise!")
	pcall(require("notify")("set + reg: blockwise!"))
end

-- https://www.reddit.com/r/vim/comments/p7xcpo/comment/h9nw69j/
--M.MarkdownHeaders = function()
--   local filename = fn.expand("%")
--   local lines = fn.getbufline('%', 0, '$')
--   local lines = fn.map(lines, {index, value -> {"lnum": index + 1, "text": value, "filename": filename}})
--   local fn.filter(lines, {_, value -> value.text =~# '^#\+ .*$'})
--   vim.cmd("call setqflist(lines)")
--   vim.cmd("copen")
--end
-- nmap <M-h> :cp<CR>
-- nmap <M-l> :cn<CR>

-- References
-- https://bit.ly/3HqvgRT
M.CountWordFunction = function()
	local hlsearch_status = vim.v.hlsearch
	local old_query = fn.getreg("/") -- save search register
	local current_word = fn.expand("<cword>")
	fn.setreg("/", current_word)
	local wordcount = fn.searchcount({ maxcount = 1000, timeout = 500 }).total
	local current_word_number = fn.searchcount({ maxcount = 1000, timeout = 500 }).current
	fn.setreg("/", old_query) -- restore search register
	print("[" .. current_word_number .. "/" .. wordcount .. "]")
	-- Below we are using the nvim-notify plugin to show up the count of words
	vim.cmd([[highlight CurrenWord ctermbg=LightGray ctermfg=Red guibg=LightGray guifg=Black]])
	vim.cmd([[exec 'match CurrenWord /\V\<' . expand('<cword>') . '\>/']])
	-- require("notify")("word '" .. current_word .. "' found " .. wordcount .. " times")
end

local transparency = 0
M.toggle_transparency = function()
	if transparency == 0 then
		vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
		local transparency = 1
	else
		vim.cmd("hi Normal guibg=#111111 ctermbg=black")
		local transparency = 0
	end
end
-- -- map('n', '<c-s-t>', '<cmd>lua require("core.utils").toggle_transparency()<br>')

-- TODO: change colors forward and backward
M.toggle_colors = function()
	local current_color = vim.g.colors_name
	if current_color == "gruvbox" then
		-- gruvbox light is very cool
		vim.cmd("colorscheme dawnfox")
		vim.cmd("colo")
		vim.cmd("redraw")
	elseif current_color == "dawnfox" then
		vim.cmd("colorscheme catppuccin")
		vim.cmd("colo")
		vim.cmd("redraw")
	elseif current_color == "catppuccin" then
		vim.cmd("colorscheme material")
		vim.cmd("colo")
		vim.cmd("redraw")
	elseif current_color == "material" then
		vim.cmd("colorscheme rose-pine")
		vim.cmd("colo")
		vim.cmd("redraw")
	elseif current_color == "rose-pine" then
		vim.cmd("colorscheme nordfox")
		vim.cmd("colo")
		vim.cmd("redraw")
	elseif current_color == "nordfox" then
		vim.cmd("colorscheme monokai")
		vim.cmd("colo")
		vim.cmd("redraw")
	elseif current_color == "monokai" then
		vim.cmd("colorscheme tokyonight")
		vim.cmd("colo")
		vim.cmd("redraw")
	else
		--vim.g.tokyonight_transparent = true
		vim.cmd("colorscheme gruvbox")
		vim.cmd("colo")
		vim.cmd("redraw")
	end
end

-- https://vi.stackexchange.com/questions/31206
-- https://vi.stackexchange.com/a/36950/7339
M.flash_cursorline = function()
	local cursorline_state = lua
	print(vim.opt.cursorline:get())
	vim.opt.cursorline = true
	vim.cmd([[hi CursorLine guifg=#FFFFFF guibg=#FF9509]])
	fn.timer_start(400, function()
		vim.cmd([[hi CursorLine guifg=NONE guibg=NONE]])
		if cursorline_state == false then
			vim.opt.cursorline = false
		end
	end)
end

-- https://www.reddit.com/r/neovim/comments/rnevjt/comment/hps3aba/
M.ToggleQuickFix = function()
	if fn.getqflist({ winid = 0 }).winid ~= 0 then
		vim.cmd([[cclose]])
	else
		vim.cmd([[copen]])
	end
end
vim.cmd([[command! -nargs=0 -bar ToggleQuickFix lua require('core.utils').ToggleQuickFix()]])
vim.cmd([[cnoreab TQ ToggleQuickFix]])
vim.cmd([[cnoreab tq ToggleQuickFix]])

-- dos2unix
M.dosToUnix = function()
	M.preserve("%s/\\%x0D$//e")
	vim.bo.fileformat = "unix"
	vim.bo.bomb = true
	vim.opt.encoding = "utf-8"
	vim.opt.fileencoding = "utf-8"
end
vim.cmd([[command! Dos2unix lua require('core.utils').dosToUnix()]])

M.preserve = function(arguments)
	local arguments = string.format("keepjumps keeppatterns execute %q", arguments)
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_command(arguments)
	local lastline = fn.line("$")
	if line > lastline then
		line = lastline
	end
	vim.api.nvim_win_set_cursor(0, { line, col })
end

--> :lua changeheader()
-- https://vi.stackexchange.com/a/5962/7339
-- This function is called with the BufWritePre event (autocmd)
-- and when I want to save a file I use ":update" which
-- only writes a buffer if it was modified
M.changeheader = function()
	-- We only can run this function if the file is modifiable
	local bufnr = vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_get_option(bufnr, "modifiable") then
		require("notify")("Current file not modifiable!")
		return
	end
	if fn.line("$") >= 7 then
		os.setlocale("en_US.UTF-8")
		local time = os.date("%a, %d %b %Y %R")
		local l = 1
		while l <= 7 do
			fn.setline(l, fn.substitute(fn.getline(l), "\\c\\vlast (change|update): \\zs.*", time, "g"))
			l = l + 1
		end
	end
end

M.is_executable = function()
	local file = fn.expand("%:p")
	local type = fn.getftype(file)
	if type == "file" then
		local perm = fn.getfperm(file)
		if string.match(perm, "x", 3) then
			return true
		else
			return false
		end
	end
end

M.ToggleHomeZero = function()
	local pos = (vim.api.nvim_win_get_cursor(0)[2] + 1)
	vim.cmd("normal! ^")
	if pos == (vim.api.nvim_win_get_cursor(0)[2] + 1) then
		vim.cmd("normal! 0")
		return
	end
	if pos == 1 then
		vim.cmd("normal! g_")
	end
end

M.increment = function(par, inc)
	if not inc then
		local inc = 1
	end
	local par = par + inc
	return par
end

M.choose_colors = function()
	local actions = require("telescope.actions")
	local actions_state = require("telescope.actions.state")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local sorters = require("telescope.sorters")
	local dropdown = require("telescope.themes").get_dropdown()

	function enter(prompt_bufnr)
		local selected = actions_state.get_selected_entry()
		local cmd = "colorscheme " .. selected[1]
		vim.cmd(cmd)
		actions.close(prompt_bufnr)
	end

	function next_color(prompt_bufnr)
		actions.move_selection_next(prompt_bufnr)
		local selected = actions_state.get_selected_entry()
		local cmd = "colorscheme " .. selected[1]
		vim.cmd(cmd)
	end

	function prev_color(prompt_bufnr)
		actions.move_selection_previous(prompt_bufnr)
		local selected = actions_state.get_selected_entry()
		local cmd = "colorscheme " .. selected[1]
		vim.cmd(cmd)
	end

	-- local colors = fn.getcompletion("", "color")

	local opts = {

		finder = finders.new_table({
			"gruvbox",
			"catppuccin",
			"material",
			"rose-pine",
			"nordfox",
			"nightfox",
			"monokai",
			"tokyonight",
		}),
		-- finder = finders.new_table(colors),
		sorter = sorters.get_generic_fuzzy_sorter({}),

		attach_mappings = function(prompt_bufnr, map)
			map("i", "<CR>", enter)
			map("i", "<C-j>", next_color)
			map("i", "<C-k>", prev_color)
			map("i", "<C-n>", next_color)
			map("i", "<C-p>", prev_color)
			return true
		end,
	}

	local colors = pickers.new(dropdown, opts)

	colors:find()
end

-- open quickfix if not empty
function M.open_qf()
	local qf_name = "quickfix"
	local qf_empty = function()
		return vim.tbl_isempty(fn.getqflist())
	end
	if not qf_empty() then
		vim.cmd("copen")
		vim.cmd("wincmd J")
	else
		print(string.format("%s is empty.", qf_name))
	end
end

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
	if plugin then
		timer = timer or 0
		vim.defer_fn(function()
			require("packer").loader(plugin)
		end, timer)
	end
end

return M
