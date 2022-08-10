-- NOTE: Remove impatient when this is merged:
-- https://github.com/neovim/neovim/pull/15436

if not pcall(require, "impatient") then
	print("impatient was not loaded")
end

if vim.g.neovide then
	vim.g.neovide_cursor_trail_legnth = 0
	vim.g.neovide_cursor_animation_length = 0
	vim.o.guifont = "Jetbrains Mono"
end

local core_modules = {
	"plugins",
	"options",
	"mappings",
	-- "keymaps",
	"autocmd",
}

-- Using pcall we can handle better any loading issues
for _, module in ipairs(core_modules) do
	local ok, err = pcall(require, module)
	if not ok then
		error("Error loading " .. module .. "\n\n" .. err)
	end
end
