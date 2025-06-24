-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g

local options = {
  guicursor = { "n-v-c:block", "i-ci-ve:ver25", "r-cr:hor20", "o:hor50" },
  modelines = 5,
  modelineexpr = false,
  modeline = true,
  cursorline = true,
  cursorcolumn = false,
  hlsearch = true,
  incsearch = true,
  hidden = true,
  autoindent = true,
  showmatch = true,
  matchtime = 2,
  linebreak = true,
  joinspaces = false,
  ttimeoutlen = 10, -- https://vi.stackexchange.com/a/4471/7339
  path = vim.opt.path + "**",
  autochdir = true,
  numberwidth = 2,
  smarttab = true,
  foldenable = false,
  foldlevel = 99,
  foldlevelstart = 99,
  foldcolumn = "1",
  showtabline = 0,
  laststatus = 3,
  confirm = false,
  cmdheight = 0,
  -- filetype = 'on', -- handled by filetypefiletype = 'on' --lugin
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- disable builtins plugins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "matchit",
  "netrw",
  "netrwFileHandlers",
  "loaded_remote_plugins",
  "loaded_tutor_mode_plugin",
  "netrwPlugin",
  "netrwSettings",
  "rrhelper",
  "spellfile_plugin",
  "tar",
  "tarPlugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "matchparen", -- matchparen.nvim disables the default
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- IMPROVE NEOVIM STARTUP
-- https://github.com/editorconfig/editorconfig-vim/issues/50
vim.g.loaded_python_provier = 0
vim.g.loaded_python3_provider = 0
vim.g.python_host_skip_check = 1
vim.g.python_host_prog = "/bin/python2"
vim.g.python3_host_skip_check = 1
vim.g.python3_host_prog = "/bin/python3"
vim.opt.pyxversion = 3
vim.g.EditorConfig_core_mode = "external_command"
-- https://vi.stackexchange.com/a/5318/7339
vim.g.matchparen_timeout = 20
vim.g.matchparen_insert_timeout = 20

if vim.fn.executable("rg") then
  -- if ripgrep installed, use that as a grepper
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end
--lua require("notify")("install ripgrep!")

if vim.fn.executable("prettier") then
  opt.formatprg = "prettier --stdin-filepath=%"
end
--lua require("notify")("Install prettier formater!")

opt.formatoptions = "l"
opt.formatoptions = opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore

opt.guicursor = {
  "n-v:block",
  "i-c-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "i:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
  "sm:block-blinkwait175-blinkoff150-blinkon175",
}

-- window-local options
local window_options = {
  numberwidth = 2,
  number = true,
  relativenumber = true,
  linebreak = true,
  cursorline = true,
  foldenable = false,
}

for k, v in pairs(window_options) do
  vim.wo[k] = v
end
