-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md

local ok, null_ls = pcall(require, "null-ls")
local b = null_ls.builtins

if not ok then
	return
end

-- local with_root_file = function(...)
--     local files = { ... }
--     return function(utils)
--         return utils.root_has_file(files)
--     end
-- end

local sources = {
	-- Lua
	b.formatting.stylua,
	-- b.diagnostics.luacheck,

	-- Shell
	b.formatting.shfmt,
	b.diagnostics.zsh,
	-- b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#(c)]" }),
	-- b.code_actions.shellcheck,

	-- Docker
	-- b.diagnostics.hadolint,

	-- b.diagnostics.ansiblelint,

	-- Golang
	-- b.diagnostics.staticcheck,
	-- b.formatting.gofumpt,

	-- JS
	-- b.formatting.eslint_d,
	-- b.diagnostics.eslint_d,
	-- b.code_actions.eslint_d,

	-- Protobuf
	-- b.formatting.protolint,
	-- b.diagnostics.protolint,

	-- Rust
	-- b.formatting.rustfmt,

	b.code_actions.gitsigns,

	-- All
	b.formatting.trim_whitespace,
	b.diagnostics.todo_comments,

	-- b.completion.spell,
	-- b.code_actions.gitrebase,
	-- b.code_actions.proselint,
	-- b.code_actions.statix
	-- Completion (handled by cmp)
	-- b.diagnostics.actionlint,
	b.diagnostics.codespell,
	-- b.diagnostics.cppcheck,
	b.diagnostics.flake8,
	-- b.diagnostics.misspell,
	-- b.diagnostics.write_good,
	-- Formatting
	-- b.formatting.beautysh,
	b.formatting.black,
	-- b.formatting.clang_format,
	-- b.formatting.jq,
	-- b.formatting.ktlint,
	-- b.formatting.markdownlint,
	b.formatting.cbfmt,
	b.formatting.prettierd,
	b.formatting.clang_format,
	b.formatting.sqlfluff.with({
		extra_args = { "--dialect", "mysql" }, -- change to your dialect
	}),
	-- b.formatting.trim_newlines,
	-- b.formatting.trim_whitespace,
	-- b.formatting.uncrustify,
	-- Hover
	-- b.hover.dictionary,
}

-- 	b.diagnostics.yamllint,
-- 	b.formatting.trim_whitespace.with({
-- 		filetypes = { "tmux", "snippets" },
-- 	}),
-- 	b.formatting.stylua.with({
-- 		condition = with_root_file("stylua.toml"),
-- 	}),
-- 	b.formatting.cbfmt.with({
-- 		condition = with_root_file(".cbfmt.toml"),
-- 	}),
-- 	-- diagnostics
-- 	b.diagnostics.selene.with({
-- 		condition = with_root_file("selene.toml"),
-- 	}),

-- NOTE: Neovim >= 0.8
-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- add to your shared on_attach callback
local on_attach = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_formatting(bufnr)
			end,
		})
	end
end

null_ls.setup({
	-- debug = true,
	sources = sources,
	on_attach = on_attach,
})
