-- source: https://bit.ly/3x8oiNR

local augroups = {}

augroups.buf_write_pre = {
	mkdir_before_saving = {
		event = { "BufWritePre", "FileWritePre" },
		pattern = "*",
		-- TODO: Replace vimscript function
		command = [[ silent! call mkdir(expand("<afile>:p:h"), "p") ]],
	},
	clear_search_highlighting = {
		event = "InsertEnter",
		pattern = "*",
		callback = function()
			vim.opt_local.hlsearch = false
			vim.fn.clearmatches()
		end,
	},
}

augroups.misc = {

	-- https://stackoverflow.com/a/60338380/2571881
	-- Mode_changed = {
	-- 	event = "ModeChanged",
	-- 	pattern = { "*:i*", "i*:*" },
	-- 	callback = function()
	-- 		if vim.bo.filetype ~= "markdown" then
	-- 			vim.o.relativenumber = vim.v.event.new_mode:match("^i") == nil
	-- 		end
	-- 	end,
	-- },

	-- change_header = {
	-- 	event = "BufWritePre",
	-- 	pattern = "*",
	-- 	callback = function()
	-- 		require("utils").changeheader()
	-- 	end,
	-- },

	clean_trailing_spaces = {
		event = "BufWritePre",
		pattern = "*",
		callback = function()
			vim.cmd([[%s/\s\+$//e]])
			vim.cmd([[%s/\n\+\%$//e]])
			--require("utils").preserve([[%s/\s\+$//e]])
			--require("utils").preserve([[%s/\n\+\%$//e]])
			-- { "BufWritePre", "*.[ch]", [[%s/\%$/\r/e]] },
		end,
	},

	-- TODO : delete these 3 autocmds
	-- update_file = { -- If you stop typing for a while it will save it!
	--     event = {"CursorHold", "CursorHoldI"},
	--     pattern = "*",
	--     callback = function()
	--         -- https://stackoverflow.com/a/69669289/2571881
	--         local buffer_name = vim.api.nvim_buf_get_name(0)
	--         if (buffer_name ~= '' or ~= nil) then
	--             vim.cmd('<buffer> silent! update')
	--         end
	--     end
	-- },

	-- -- https://www.reddit.com/r/neovim/comments/mn7coe/
	-- lsp_diagnostic = {
	--     event = "CursorHold",
	--     pattern = "*",
	--     callback = function()
	--         vim.lsp.diagnostic.show_line_diagnostics()
	--     end,
	-- },
	--
	-- ls_signature = {
	--     event = "CursorHoldI",
	--     pattern = "*",
	--     callback = function()
	--         vim.lsp.buf.signature_help()
	--     end,
	-- },

	unlist_terminal = {
		event = "TermOpen",
		pattern = "*",
		command = [[
    tnoremap <buffer> <Esc> <c-\><c-n>
    tnoremap <buffer> <leader>x <c-\><c-n>:bd!<cr>
    tnoremap <expr> <A-r> '<c-\><c-n>"'.nr2char(getchar()).'pi'
    startinsert
    nnoremap <buffer> <C-c> i<C-c>
    setlocal listchars= nonumber norelativenumber
    setlocal nobuflisted
    ]],
	},

	fix_commentstring = {
		event = "BufEnter",
		pattern = "*config,*rc,*conf,sxhkdrc,bspwmrc",
		callback = function()
			vim.bo.commentstring = "#%s"
			vim.cmd("set syntax=config")
		end,
	},

	-- reload_myvimrc = {
	--     event = "BufWritePre",
	--     pattern = "$MYVIMRC",
	--     callback = function()
	--     ReloadConfig()
	--     end,
	-- },

	compile_python = {
		event = "BufWritePost",
		pattern = "*.py",
		command = [[!python -m py_compile %]],
	},

	reload_sxhkd = {
		event = "BufWritePost",
		pattern = "sxhkdrc",
		command = [[!pkill -USR1 -x sxhkd]],
	},

	make_scripts_executable = {
		event = "BufWritePost",
		pattern = "*.{sh,py,zsh}",
		callback = function()
			local file = vim.fn.expand("%p")
			local status = require("core.utils").is_executable()
			if status ~= true then
				vim.fn.setfperm(file, "rwxr-x---")
			end
		end,
	},

	update_xrdb = {
		event = "BufWritePost",
		pattern = "Xresources,Xdefaults,xresources,xdefaults",
		command = [[!xrdb -merge %]],
	},
	updated_xdefaults = {
		event = "BufWritePost",
		pattern = "~/.Xdefaults",
		command = [[!xrdb -merge ~/.Xdefaults]],
	},

	restore_cursor_position = {
		event = "BufRead",
		pattern = "*",
		command = [[call setpos(".", getpos("'\""))]],
	},

	lwindow_quickfix = {
		event = "QuickFixCmdPost",
		pattern = "l*",
		command = [[lwindow | wincmd j]],
	},

	cwindow_quickfix = {
		event = "QuickFixCmdPost",
		pattern = "[^l]*",
		command = [[cwindow | wincmd j]],
	},
	-- auto_working_directory = {
	--     event = "BufEnter",
	--     pattern = "*",
	--     callback = function()
	--         vim.cmd("silent! lcd %:p:h")
	--     end,
	-- },
}

augroups.yankpost = {

	save_cursor_position = {
		event = { "VimEnter", "CursorMoved" },
		pattern = "*",
		callback = function()
			cursor_pos = vim.fn.getpos(".")
		end,
	},

	highlight_yank = {
		event = "TextYankPost",
		pattern = "*",
		callback = function()
			vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400, on_visual = true })
		end,
	},

	yank_restore_cursor = {
		event = "TextYankPost",
		pattern = "*",
		callback = function()
			local cursor = vim.fn.getpos(".")
			if vim.v.event.operator == "y" then
				vim.fn.setpos(".", cursor_pos)
			end
		end,
	},
}

-- Note: some Filetype's have their own ftplugin, that's why you cannot see help and qf here
augroups.quit = {
	quit_with_q = {
		event = "FileType",
		pattern = { "checkhealth", "fugitive", "git*", "lspinfo" },
		callback = function()
			-- vim.api.nvim_win_close(0, true) -- TODO: Replace vim command with this
			vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<cr>", { noremap = true, silent = true })
			vim.bo.buflisted = false
		end,
	},
}

for group, commands in pairs(augroups) do
	local augroup = vim.api.nvim_create_augroup("AU_" .. group, { clear = true })

	for _, opts in pairs(commands) do
		local event = opts.event
		opts.event = nil
		opts.group = augroup
		vim.api.nvim_create_autocmd(event, opts)
	end
end
