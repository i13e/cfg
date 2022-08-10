-- Reference: https://github.com/goolord/alpha-nvim
-- Configuration examples: https://github.com/goolord/alpha-nvim/discussions/16

if not pcall(require, "alpha") then
	return
end

local db = require("alpha.themes.dashboard")

-- Footer
local function footer()
	local version = vim.version()
	local print_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
	local datetime = os.date("%a %d %R")

	return print_version .. " " .. datetime
end

-- Banner
local banner = {
	"                                                    ",
	" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
	" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
	" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
	" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
	" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
	" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
	"                                                    ",
}

db.section.header.val = banner

-- Menu
db.section.buttons.val = {
	db.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
	db.button("f", "  Find file", ":NvimTreeToggle<CR>"),
	-- db.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
	-- db.button("n", "  docs index", "<cmd>e /home/barbaross/Documents/index.md<cr>"),
	db.button("s", "  Settings", ":e $MYVIMRC<CR>"),
	db.button("u", "  Update plugins", ":PackerUpdate<CR>"),
	db.button("q", "  Quit", ":qa<CR>"),
}

db.section.footer.val = footer()

require("alpha").setup(db.config)
