local map_fzf = function(mode, key, f, options, buffer)
	local desc = nil
	if type(options) == "table" then
		desc = options.desc
		options.desc = nil
	elseif type(options) == "function" then
		desc = options().desc
	end

	local rhs = function()
		if not pcall(require, "fzf-lua") then
			require("packer").loader("fzf-lua")
		end
		require("fzf-lua")[f](options or {})
	end

	local map_options = {
		silent = true,
		buffer = buffer,
		desc = desc or string.format("FzfLua %s", f),
	}

	vim.keymap.set(mode, key, rhs, map_options)
end

-- mappings
map_fzf("n", "<F1>", "help_tags", { desc = "help tags" })
map_fzf("n", "<leader>fM", "man_pages", { desc = "man pages" })

map_fzf("n", "<c-P>", "files", { desc = "find files" })
map_fzf("n", "<c-K>", "workdirs", {
	desc = "cwd workdirs",
	winopts = {
		height = 0.40,
		width = 0.60,
		row = 0.40,
	},
})

map_fzf("n", "<leader>fp", "files", {
	desc = "plugin files (packer)",
	prompt = "Plugins❯ ",
	cwd = vim.fn.stdpath("data") .. "/site/pack/packer/",
})

map_fzf("n", "<leader>f?", "builtin", { desc = "builtin commands" })
map_fzf("n", "<leader>;", "buffers", { desc = "Fzf buffers" })
map_fzf("n", "<leader>ff", "resume", { desc = "resume" })
map_fzf("n", "<leader>fm", "marks", { desc = "marks" })
map_fzf("n", "<leader>fx", "commands", { desc = "commands" })
map_fzf("n", "<leader>f:", "command_history", { desc = "command history" })
map_fzf("n", "<leader>f/", "search_history", { desc = "search history" })
map_fzf("n", '<leader>f"', "registers", { desc = "registers" })
map_fzf("n", "<leader>fk", "keymaps", { desc = "keymaps" })
map_fzf("n", "<leader>fz", "spell_suggest", {
	desc = "spell suggestions",
	winopts = {
		win_height = 0.60,
		win_width = 0.50,
		win_row = 0.40,
	},
})
map_fzf("n", "<leader>fT", "tags", { desc = "tags (project)" })
map_fzf("n", "<leader>ft", "btags", { desc = "tags (buffer)" })

map_fzf("n", "<leader>fr", "grep", { desc = "grep string (prompt)" })
map_fzf("n", "<leader>fR", "grep", { desc = "grep string resume", resume = true })
map_fzf("n", "<leader>fw", "grep_cword", { desc = "grep <word> (project)" })
map_fzf("n", "<leader>fW", "grep_cWORD", { desc = "grep <WORD> (project)" })
map_fzf("n", "<leader>fv", "grep_visual", { desc = "grep visual selection" })
map_fzf("v", "<leader>fv", "grep_visual", { desc = "grep visual selection" })
map_fzf("n", "<leader>fb", "blines", { desc = "fuzzy buffer lines" })
map_fzf("n", "<leader>fB", "lgrep_curbuf", { desc = "live grep (buffer)", prompt = "Buffer❯ " })
map_fzf("n", "<leader>fl", "live_grep", { desc = "live grep (project)" })
map_fzf("n", "<leader>fL", "live_grep", { desc = "live grep resume", resume = true })

map_fzf("n", "<leader>f3", "blines", function()
	return {
		desc = "blines <word>",
		fzf_opts = { ["--query"] = vim.fn.expand("<cword>") },
	}
end)
map_fzf("n", "<leader>f8", "grep_curbuf", function()
	return {
		desc = "grep <word> (buffer)",
		prompt = "Buffer❯ ",
		search = vim.fn.expand("<cword>"),
	}
end)
map_fzf("n", "<leader>f*", "grep_curbuf", function()
	return {
		desc = "grep <WORD> (buffer)",
		prompt = "Buffer❯ ",
		search = vim.fn.expand("<cWORD>"),
	}
end)
map_fzf("n", "<leader>fH", "oldfiles", { desc = "file history (all)", cwd = "~" })
map_fzf("n", "<leader>fh", "oldfiles", function()
	return {
		desc = "file history (cwd)",
		cwd = vim.loop.cwd(),
		show_cwd_header = true,
		cwd_only = true,
	}
end)

map_fzf("n", "<leader>f0", "tmux_buffers", { desc = "tmux paste buffers" })
map_fzf("n", "<leader>fq", "quickfix", { desc = "quickfix list" })
map_fzf("n", "<leader>fQ", "loclist", { desc = "location list" })
map_fzf("n", "<leader>fO", "highlights", { desc = "colorscheme highlights" })
map_fzf("n", "<leader>fo", "colorschemes", {
	desc = "colorschemes",
	winopts = { height = 0.45, width = 0.30 },
})

-- LSP
map_fzf("n", "<leader>lr", "lsp_references", { desc = "references [LSP]" })
map_fzf("n", "<leader>ld", "lsp_definitions", { desc = "definitions [LSP]", jump_to_single_result = false })
map_fzf("n", "<leader>lD", "lsp_declarations", { desc = "declarations [LSP]" })
map_fzf("n", "<leader>ly", "lsp_typedefs", { desc = "type definitions [LSP]" })
map_fzf("n", "<leader>lm", "lsp_implementations", { desc = "implementations [LSP]" })
map_fzf("n", "<leader>ls", "lsp_document_symbols", { desc = "document symbols [LSP]" })
map_fzf("n", "<leader>lS", "lsp_workspace_symbols", { desc = "workspace symbols [LSP]" })
map_fzf("n", "<leader>la", "lsp_code_actions", {
	desc = "code actions [LSP]",
	winopts = {
		win_height = 0.30,
		win_width = 0.70,
		win_row = 0.40,
	},
})
map_fzf("n", "<leader>lg", "lsp_document_diagnostics", { desc = "document diagnostics [LSP]" })
map_fzf("n", "<leader>lG", "lsp_workspace_diagnostics", { desc = "workspace diagnostics [LSP]" })

-- Git
map_fzf("n", "<leader>gf", "git_files", { desc = "git ls-files" })
map_fzf("n", "<leader>gs", "git_status", { desc = "git status" })
map_fzf("n", "<leader>gB", "git_branches", { desc = "git branches" })
map_fzf("n", "<leader>gc", "git_bcommits", { desc = "git commits (buffer)" })
map_fzf("n", "<leader>gC", "git_commits", { desc = "git commits (project)" })
-- Full screen git status
map_fzf("n", "<leader>gS", "git_status_tmuxZ", {
	desc = "git status (fullscreen)",
	winopts = {
		fullscreen = true,
		preview = {
			vertical = "down:70%",
			horizontal = "right:70%",
		},
	},
})

-- yadm repo
local yadm_git_dir = "$HOME/dots/yadm-repo"
local yadm_cmd = string.format("yadm -C $HOME --yadm-repo %s", yadm_git_dir)
local yadm_git_opts = {
	show_cwd_header = false,
	git_dir = "$HOME/dots/yadm-repo",
}
local yadm_grep_opts = {
	prompt = "YadmGrep❯ ",
	cwd = "$HOME",
	cmd = ("%s grep --line-number --column --color=always"):format(yadm_cmd),
	rg_glob = false, -- this isn't `rg`
}

map_fzf(
	"n",
	"<leader>yf",
	"git_files",
	vim.tbl_extend("force", yadm_git_opts, { desc = "yadm ls-files", prompt = "YadmFiles> " })
)
map_fzf("n", "<leader>yg", "grep_project", vim.tbl_extend("force", yadm_grep_opts, { desc = "yadm grep" }))
map_fzf("n", "<leader>yl", "live_grep", vim.tbl_extend("force", yadm_grep_opts, { desc = "yadm live grep" }))
map_fzf("n", "<leader>yb", "git_branches", vim.tbl_extend("force", yadm_git_opts, { desc = "yadm branches" }))
map_fzf("n", "<leader>yC", "git_commits", vim.tbl_extend("force", yadm_git_opts, { desc = "yadm commits (project)" }))
map_fzf("n", "<leader>yc", "git_bcommits", vim.tbl_extend("force", yadm_git_opts, { desc = "yadm commits (buffer)" }))

map_fzf(
	"n",
	"<leader>ys",
	"git_status",
	vim.tbl_extend("force", yadm_git_opts, { desc = "yadm status", cmd = "git status -s", prompt = "YadmStatus> " })
)
map_fzf(
	"n",
	"<leader>es",
	"git_status",
	vim.tbl_extend("force", yadm_git_opts, { desc = "yadm status", cmd = "git status -s", prompt = "YadmStatus> " })
)

map_fzf(
	"n",
	"<leader>yS",
	"git_status_tmuxZ",
	vim.tbl_extend("force", yadm_git_opts, {
		desc = "yadm status (fullscreen)",
		prompt = "YadmStatus> ",
		cmd = "git status -s",
		winopts = {
			fullscreen = true,
			preview = {
				vertical = "down:70%",
				horizontal = "right:70%",
			},
		},
	})
)
