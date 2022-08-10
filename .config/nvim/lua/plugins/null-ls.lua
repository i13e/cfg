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
	-- TODO Completions?
	--b.completion.spell,
	-- code_actions
	b.code_actions.gitsigns,
	-- b.code_actions.proselint,
	-- b.code_actions.shellcheck,
	-- formatting
	b.formatting.black,
	b.formatting.prettierd,
	b.formatting.shfmt,
	-- b.formatting.beautysh,
	b.formatting.stylua,
	--b.formatting.ktlint,
	--b.formatting.markdownlint,
	-- diagnostics
	b.diagnostics.flake8,
	b.diagnostics.zsh,
	--b.diagnostics.shellcheck,
	--b.diagnostics.misspell,
	--b.diagnostics.codespell,
	--b.diagnostics.actionlint,
	-- hover
	-- b.hover.dictionary,
}

-- local sources = {
-- 	-- formatting
-- 	b.formatting.jq,
-- 	b.formatting.uncrustify,
-- 	b.formatting.clang_format,
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
-- 	b.diagnostics.write_good,
-- 	b.diagnostics.cppcheck,
-- 	b.diagnostics.yamllint,
-- 	-- code actions
-- 	b.code_actions.gitrebase,
-- }

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
