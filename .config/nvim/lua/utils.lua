local execute = vim.api.nvim_command
local opt = vim.opt -- global
local g = vim.g -- global for let options
local wo = vim.wo -- window local
local bo = vim.bo -- buffer local
local fn = vim.fn -- access vim functions
local cmd = vim.cmd -- vim commands
local api = vim.api -- access vim api

function _G.reload(package)
	package.loaded[package] = nil
	return require(package)
end

local M = {}

-- https://blog.devgenius.io/create-custom-keymaps-in-neovim-with-lua-d1167de0f2c2
-- https://oroques.dev/notes/neovim-init/
M.map = function(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap(mode, lhs, rhs, options)
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
	print("set + reg: blockwise!")
end

-- https://www.reddit.com/r/vim/comments/p7xcpo/comment/h9nw69j/
--M.MarkdownHeaders = function()
--   local filename = vim.fn.expand("%")
--   local lines = vim.fn.getbufline('%', 0, '$')
--   local lines = vim.fn.map(lines, {index, value -> {"lnum": index + 1, "text": value, "filename": filename}})
--   local vim.fn.filter(lines, {_, value -> value.text =~# '^#\+ .*$'})
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
-- -- map('n', '<c-s-t>', '<cmd>lua require("utils").toggle_transparency()<br>')

-- -- TODO: change colors forward and backward
-- M.toggle_colors = function()
--     local current_color = vim.g.colors_name
--     if current_color == "gruvbox" then
--         -- gruvbox light is very cool
--         vim.cmd("colorscheme dawnfox")
--         vim.cmd("colo")
-- 		vim.cmd("redraw")
--     elseif current_color == "dawnfox" then
--         vim.cmd("colorscheme catppuccin")
--         vim.cmd("colo")
-- 		vim.cmd("redraw")
--     elseif current_color == "catppuccin" then
--         vim.cmd("colorscheme material")
--         vim.cmd("colo")
-- 		vim.cmd("redraw")
--     elseif current_color == "material" then
--         vim.cmd("colorscheme rose-pine")
--         vim.cmd("colo")
-- 		vim.cmd("redraw")
--     elseif current_color == "rose-pine" then
--         vim.cmd("colorscheme nordfox")
--         vim.cmd("colo")
-- 		vim.cmd("redraw")
--     elseif current_color == "nordfox" then
--         vim.cmd("colorscheme monokai")
--         vim.cmd("colo")
-- 		vim.cmd("redraw")
--     elseif current_color == "monokai" then
--         vim.cmd("colorscheme tokyonight")
--         vim.cmd("colo")
-- 		vim.cmd("redraw")
--     else
--         --vim.g.tokyonight_transparent = true
--         vim.cmd("colorscheme gruvbox")
--         vim.cmd("colo")
-- 		vim.cmd("redraw")
--     end
-- end

-- https://vi.stackexchange.com/questions/31206
-- https://vi.stackexchange.com/a/36950/7339
M.flash_cursorline = function()
	local cursorline_state = print(opt.cursorline:get())
	opt.cursorline = true
	cmd([[hi CursorLine guifg=#FFFFFF guibg=#FF9509]])
	fn.timer_start(200, function()
		vim.cmd([[hi CursorLine guifg=NONE guibg=NONE]])
		if cursorline_state == false then
			opt.cursorline = false
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
vim.cmd([[command! -nargs=0 -bar ToggleQuickFix lua require('utils').ToggleQuickFix()]])
vim.cmd([[cnoreab TQ ToggleQuickFix]])
vim.cmd([[cnoreab tq ToggleQuickFix]])

-- dos2unix
M.dosToUnix = function()
	M.preserve("%s/\\%x0D$//e")
	bo.fileformat = "unix"
	bo.bomb = true
	opt.encoding = "utf-8"
	opt.fileencoding = "utf-8"
end
vim.cmd([[command! Dos2unix lua require('core.utils').dosToUnix()]])

M.squeeze_blank_lines = function()
	-- references: https://vi.stackexchange.com/posts/26304/revisions
	if bo.binary == false and opt.filetype:get() ~= "diff" then
		local old_query = fn.getreg("/") -- save search register
		M.preserve("sil! 1,.s/^\\n\\{2,}/\\r/gn") -- set current search count number
		local result = fn.searchcount({ maxcount = 1000, timeout = 500 }).current
		local line, col = unpack(api.nvim_win_get_cursor(0))
		M.preserve("sil! keepp keepj %s/^\\n\\{2,}/\\r/ge")
		M.preserve("sil! keepp keepj %s/^\\s\\+$/\\r/ge")
		M.preserve("sil! keepp keepj %s/\\v($\\n\\s*)+%$/\\r/e")
		if result > 0 then
			api.nvim_win_set_cursor(0, { (line - result), col })
		end
		fn.setreg("/", old_query) -- restore search register
	end
end

-- https://neovim.discourse.group/t/reload-init-lua-and-all-require-d-scripts/971/11
M.ReloadConfig = function()
	local hls_status = vim.v.hlsearch
	for name, _ in pairs(package.loaded) do
		if name:match("^cnull") then
			package.loaded[name] = nil
		end
	end
	dofile(vim.env.MYVIMRC)
	if hls_status == 0 then
		opt.hlsearch = false
	end
end

M.preserve = function(arguments)
	local arguments = string.format("keepjumps keeppatterns execute %q", arguments)
	-- local original_cursor = fn.winsaveview()
	local line, col = unpack(api.nvim_win_get_cursor(0))
	api.nvim_command(arguments)
	local lastline = fn.line("$")
	-- fn.winrestview(original_cursor)
	if line > lastline then
		line = lastline
	end
	api.nvim_win_set_cursor(0, { line, col })
end

--> :lua changeheader()
-- This function is called with the BufWritePre event (autocmd)
-- and when I want to save a file I use ":update" which
-- only writes a buffer if it was modified
M.changeheader = function()
	-- We only can run this function if the file is modifiable
	if not api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "modifiable") then
		return
	end
	if fn.line("$") >= 7 then
		os.setlocale("en_US.UTF-8") -- show Sun instead of dom (portuguese)
		time = os.date("%a, %d %b %Y %R")
		M.preserve("sil! keepp keepj 1,7s/\\vlast (modified|change):\\zs.*/ " .. time .. "/ei")
	end
end

-- M.choose_colors = function()
--     local actions = require "telescope.actions"
--     local actions_state = require "telescope.actions.state"
--     local pickers = require "telescope.pickers"
--     local finders = require "telescope.finders"
--     local sorters = require "telescope.sorters"
--     local dropdown = require "telescope.themes".get_dropdown()
--
--     function enter(prompt_bufnr)
--         local selected = actions_state.get_selected_entry()
--         local cmd = 'colorscheme ' .. selected[1]
--         vim.cmd(cmd)
--         actions.close(prompt_bufnr)
--     end
--
--     function next_color(prompt_bufnr)
--         actions.move_selection_next(prompt_bufnr)
--         local selected = actions_state.get_selected_entry()
--         local cmd = 'colorscheme ' .. selected[1]
--         vim.cmd(cmd)
--     end
--
--     function prev_color(prompt_bufnr)
--         actions.move_selection_previous(prompt_bufnr)
--         local selected = actions_state.get_selected_entry()
--         local cmd = 'colorscheme ' .. selected[1]
--         vim.cmd(cmd)
--     end
--
--     -- local colors = fn.getcompletion("", "color")
--
--     local opts = {
--
--         finder = finders.new_table {"gruvbox", "catppuccin", "material", "rose-pine", "nordfox", "nightfox", "monokai", "tokyonight"},
--         -- finder = finders.new_table(colors),
--         sorter = sorters.get_generic_fuzzy_sorter({}),
--
--         attach_mappings = function(prompt_bufnr, map)
--             map("i", "<CR>", enter)
--             map("i", "<C-j>", next_color)
--             map("i", "<C-k>", prev_color)
--             map("i", "<C-n>", next_color)
--             map("i", "<C-p>", prev_color)
--             return true
--         end,
--
--     }
--
--     local colors = pickers.new(dropdown, opts)
--
--     colors:find()
-- end

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
