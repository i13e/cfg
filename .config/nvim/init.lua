if not pcall(require, "impatient") then
	print("impatient was not loaded")
end

local core_modules = {
	"plugins",
	"options",
	"mappings",
	-- "keymaps",
	"autocmd",
	"new-autocmd",
}

-- Using pcall we can handle better any loading issues
for _, module in ipairs(core_modules) do
	local ok, err = pcall(require, module)
	if not ok then
		error("Error loading " .. module .. "\n\n" .. err)
	end
end
