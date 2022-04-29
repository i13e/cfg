-- =============================
-- general configuration
-- =============================

-- aliases (NOTE: vim.opt is better than vim.o)
local opt = vim.opt -- global
local g = vim.g -- global for let options
--local wo = vim.wo -- window local
--local bo = vim.bo -- buffer local
--local map = vim.keymap.set -- for keybindings
local fn = vim.fn -- access vim functions
local cmd = vim.cmd -- vim commands
--local env = vim.env -- gets/sets env variables
--local map = require('user.utils').map -- import map helper

cmd("colo nord")

-- IMPROVE NEOVIM STARTUP
-- https://github.com/editorconfig/editorconfig-vim/issues/50
g.loaded_python_provier = 0
g.loaded_python3_provider = 0
g.python_host_skip_check = 1
g.python3_host_skip_check = 1
g.python3_host_prog = "/usr/bin/python"
opt.pyxversion = 3
-- if vim.fn.executable("editorconfig") then
--  g.EditorConfig_exec_path = '/bin/editorconfig'
-- end
g.EditorConfig_core_mode = "external_command"

-- https://vi.stackexchange.com/a/5318/7339
g.matchparen_timeout = 20
g.matchparen_insert_timeout = 20

-- Disable providers we do not care a about
-- vim.g.loaded_python_provider  = 0
-- vim.g.loaded_ruby_provider    = 0
-- vim.g.loaded_perl_provider    = 0
-- vim.g.loaded_node_provider    = 0

-- disable some built-in plugins completely
local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
	--"fzf",
	--"loaded_remote_plugins",
	--"loaded_tutor_mode_plugin",
	"matchit",
	"matchparen", -- matchparen.nvim disables the default
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

g.do_filetype_lua = 1
g.did_load_filetypes = 0

g.mapleader = ","

--cmd("hi normal guibg=NONE ctermbg=NONE")
-- https://www.codesd.com/item/how-do-i-open-the-quickfix-window-instead-of-displaying-grep-results.html
-- cmd([[command! -bar -nargs=1 Grep silent grep <q-args> | redraw! | cw]])
cmd([[cnoreab cls Cls]])
cmd([[command! Cls lua require("core.utils").preserve('%s/\\s\\+$//ge')]])
cmd([[command! Reindent lua require('core.utils').preserve("sil keepj normal! gg=G")]])
cmd([[command! BufOnly lua require('core.utils').preserve("silent! %bd|e#|bd#")]])
cmd([[cnoreab Bo BufOnly]])
cmd([[cnoreab W w]])
cmd([[cnoreab W! w!]])
cmd([[command! CloneBuffer new | 0put =getbufline('#',1,'$')]])
cmd([[command! Mappings drop ~/.config/nvim/lua/user/mappings.lua]])
cmd([[command! Scratch new | setlocal bt=nofile bh=wipe nobl noswapfile nu]])
cmd([[syntax sync minlines=64]]) --  faster syntax hl

-- save as root
cmd([[cmap w!! w !sudo tee % >/dev/null]])
cmd([[command! SaveAsRoot w !sudo tee %]])

-- cmd([[hi ActiveWindow ctermbg=16 | hi InactiveWindow ctermbg=233]])
-- cmd([[set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow]])

cmd('command! ReloadConfig lua require("core.utils").ReloadConfig()')

-- inserts filename and Last Change: date
cmd([[inoreab lc -- File: <c-r>=expand("%:p")<cr><cr>-- Last Change: <c-r>=strftime("%b %d %Y - %H:%M")<cr><cr>]])

cmd([[inoreab Fname <c-r>=expand("%:p")<cr>]])
cmd([[inoreab Iname <c-r>=expand("%:p")<cr>]])
cmd([[inoreab fname <c-r>=expand("%:t")<cr>]])
cmd([[inoreab iname <c-r>=expand("%:t")<cr>]])

cmd([[inoreabbrev idate <C-R>=strftime("%b %d %Y %H:%M")<CR>]])
cmd([[cnoreab cls Cls]])

cmd([[highlight RedundantSpaces ctermbg=red guibg=red ]])
cmd([[match RedundantSpaces /\s\+$/]])

-- let undos expire after 30 days
cmd([[let s:undos = split(globpath(&undodir, '*'), "\n")
call filter(s:undos, 'getftime(v:val) < localtime() - (60 * 60 * 24 * 30)')
call map(s:undos, 'delete(v:val)')
]])




local options = {
	mouse = "a", -- enable the mouse
	exrc = false, -- ignore '~/.exrc'
	secure = true,
	--modelines = 1, -- read a modeline at EOF
	errorbells = false, -- disable error bells (no beep/flash)
	termguicolors = true, -- enable 24bit colors

	updatetime = 250, -- decrease update time
	fileformat = "unix", -- <nl> for EOL
	switchbuf = "useopen",
	encoding = "utf-8",
	fileencoding = "utf-8",
	backspace = { "eol", "start", "indent" },
	matchpairs = { "(:)", "{:}", "[:]", "<:>" },

	showmode = false, -- show current mode (insert, etc) under the cmdline
	--showcmd = true, -- show current command under the cmd line
	cmdheight = 2, -- cmdline height
	cmdwinheight = math.floor(vim.o.lines / 2), -- 'q:' window height
	laststatus = 3 or 2, -- global statusline
	scrolloff = 3, -- min number of lines to keep between cursor and screen edge
	sidescrolloff = 5, -- min number of cols to keep between cursor and screen edge
	textwidth = 78, -- max inserted text width for paste operations
	linespace = 0, -- font spacing
	ruler = true, -- show line,col at the cursor pos
	number = true, -- show absolute line no. at the cursor pos
	--relativenumber = true, -- otherwise, show relative numbers in the ruler
	cursorline = true, -- Show a line where the current cursor is
	signcolumn = "yes", -- "yes:1" Show sign column as first column
	--vim.g.colorcolumn = 81 -- global var, mark column 81
	--opt.colorcolumn = tostring(vim.g.colorcolumn)
	wrap = true, -- wrap long lines
	breakindent = true, -- start wrapped lines indented
	linebreak = true, -- do not break words on line wrap

	-- Characters to display on ':set list',explore glyphs using:
	-- `xfd -fa "InputMonoNerdFont:style:Regular"` or
	-- `xfd -fn "-misc-fixed-medium-r-semicondensed-*-13-*-*-*-*-*-iso10646-1"`
	-- input special chars with the sequence <C-v-u> followed by the hex code
	list = false,
	listchars = {
		tab = "▶ ",
		eol = "↲",
		nbsp = "␣",
		lead = " ",
		space = " ",
		trail = "•",
		--lead     = "␣" ,
		--space    = "␣" ,
		--trail    = '␣' ,
		extends = "»",
		precedes = "«",
	},
	--showbreak = '↪ ',

	-- show menu even for one item do not auto select/insert
	completeopt = { "noinsert", "menuone", "noselect" }, --menu
	wildmenu = true,
	wildmode = "longest:full,full",
	wildoptions = "pum", -- show completion items using pop-up-menu (pum)
	pumblend = 15, -- completion menu transparency

	joinspaces = true, -- insert spaces after '.?!' when joining lines
	autoindent = true, -- copy indent from current line on newline
	smartindent = true, -- add <tab> depending on syntax (C/C++)
	startofline = false, -- keep cursor column on navigation

	tabstop = 4, -- Tab indentation levels every two columns
	softtabstop = 4, -- Tab indentation when mixing tabs & spaces
	shiftwidth = 4, -- Indent/outdent by two columns
	shiftround = true, -- Always indent/outdent to nearest tabstop
	expandtab = true, -- Convert all tabs that are typed into spaces
	smarttab = true, -- Use shiftwidths at left margin, tabstops everywhere else

	-- c: auto-wrap comments using textwidth
	-- r: auto-insert the current comment leader after hitting <Enter>
	-- o: auto-insert the current comment leader after hitting 'o' or 'O'
	-- q: allow formatting comments with 'gq'
	-- n: recognize numbered lists
	-- 1: don't break a line after a one-letter word
	-- j: remove comment leader when it makes sense
	-- this gets overwritten by ftplugins (:verb set fo)
	-- we use autocmd to remove 'o' in '/lua/autocmd.lua'
	-- borrowed from tjdevries
	--opt.formatoptions = "l"
	formatoptions = opt.formatoptions
		- "a" -- Auto formatting is BAD.
		- "t" -- Don't auto format my code. I got linters for that.
		+ "c" -- In general, I like it when comments respect textwidth
		+ "q" -- Allow formatting comments w/ gq
		- "o" -- O and o, don't continue comments
		+ "r" -- But do continue when pressing enter.
		+ "n" -- Indent past the formatlistpat, not underneath it.
		+ "j" -- Auto-remove comments if possible.
		- "2", -- I'm not in gradeschool anymore

	splitbelow = true, -- ":new" ":split" below current
	splitright = true, -- ":vnew" ":vsplit" right of current

	foldenable = false, -- true, enable folding
	foldlevelstart = 10, -- open most folds by default
	foldnestmax = 10, -- 10 nested fold max
	foldmethod = "indent", -- fold based on indent level

	undofile = true,
	hidden = true, -- do not unload buffer when abandoned
	--autochdir         = false,     -- do not change dir when opening a file

	magic = true, --  use 'magic' chars in search patterns
	hlsearch = true, -- highlight all text matching current search pattern
	incsearch = true, -- show search matches as you type
	ignorecase = true, -- ignore case on search
	smartcase = true, -- case sensitive when search includes uppercase
	showmatch = true, -- highlight matching [{()}]
	inccommand = "nosplit", -- show search and replace in real time
	autoread = true, -- reread a file if it's changed outside of vim
	wrapscan = true, -- begin search from top of the file when nothing is found
	cpoptions = vim.o.cpoptions .. "x", -- stay on search item when <esc>

	--undodir = "/tmp",
	title = true,
	fillchars = { eob = "~" },
	syntax = "ON", -- str:  Allow syntax highlighting
	foldopen = vim.opt.foldopen + "jump", -- when jumping to the line auto-open the folder
	path = vim.opt.path + { "~/.config/nvim/lua/user", "**" },
	wildignore = {
		".git",
		".hg",
		".svn",
		"*.pyc",
		"*.o",
		"*.out",
		"*.jpg",
		"*.jpeg",
		"*.png",
		"*.gif",
		"*.zip",
		"**/node_modules/**",
		"**/bower_modules/**",
		"__pycache__",
		"*~",
		"*.DS_Store",
		"**/undo/**",
		"*[Cc]ache/",
	},
	wildignorecase = true,
	infercase = true,
	lazyredraw = true,
	matchtime = 2,
	synmaxcol = 128, -- avoid slow rendering for long lines
	shell = "/bin/zsh",
	pumheight = 10,
	clipboard = vim.opt.clipboard + { "unnamedplus" }, -- enable copy to system clipboard
	timeoutlen = 500,
	spelllang = { "en_us" },
	ttimeoutlen = 10, -- https://vi.stackexchange.com/a/4471/7339
	ssop = vim.opt.ssop - { "blank", "help", "buffers" } + { "terminal" },
	modelines = 5,
	modelineexpr = false,
	modeline = true,
	emoji = false, -- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
	shada = "!,'30,<30,s30,h,:30,%0,/30",
	whichwrap = opt.whichwrap:append("<>[]hl"),
	iskeyword = opt.iskeyword:append("-"),
}

for k, v in pairs(options) do
	opt[k] = v
end

-- use ':grep' to send resulsts to quickfix
-- use ':lgrep' to send resulsts to loclist
if vim.fn.executable("rg") == 1 then
	opt.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
	opt.grepformat = "%f:%l:%c:%m"
end
--if fn.executable("rg") then
--    -- if ripgrep installed, use that as a grepper
--    opt.grepprg = "rg --vimgrep --no-heading --smart-case"
--    opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
--end
--lua require("notify")("install ripgrep!")

if fn.executable("prettier") then
	opt.formatprg = "prettier --stdin-filepath=%"
end
--lua require("notify")("Install prettier formater!")

opt.guicursor = {
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
	"o:hor50",
	"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
	"sm:block-blinkwait175-blinkoff150-blinkon175",
}
g.markdown_fenced_languages = {
	"vim",
	"lua",
	"cpp",
	"sql",
	"python",
	"bash=sh",
	"console=sh",
	"javascript",
	"typescript",
	"js=javascript",
	"ts=typescript",
	"yaml",
	"json",
}
-- window-local options
--window_options = {
--numberwidth = 2,
--relativenumber = true,
--number = true,
--linebreak = true,
--cursorline = false,
--foldenable = false,
--}

--for k, v in pairs(window_options) do
--    wo[k] = v
--end

-- buffer-local options
--buffer_options = {
--    expandtab = true,
--    softtabstop = 4,
--    tabstop = 4,
--    shiftwidth = 4,
--    smartindent = true,
--    suffixesadd = '.lua'
--}

--for k, v in pairs(buffer_options) do
--    bo[k] = v
--end

g.nojoinspaces = true

-- cmd [[colorscheme nord]]                -- colorscheme selection
-- opt.clipboard:append {"unnamedplus"}    -- enable copy to system clipboard
-- opt.path = vim.opt.path + '.,**'

local core_modules = {
	"plugins",
	"autocmd",
	"mappings",
}

-- Using pcall we can handle better any loading issues
for _, module in ipairs(core_modules) do
	local ok, err = pcall(require, module)
	if not ok then
		error("Error loading " .. module .. "\n\n" .. err)
	end
end
