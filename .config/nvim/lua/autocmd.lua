-- Last Change: Fri, 29 Apr 2022 14:34

--- This function is taken from https://github.com/norcalli/nvim_utils
function nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command("augroup " .. group_name)
        vim.api.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command("augroup END")
    end
end

local autocmds = {
    reload_vimrc = {
        -- Reload vim config automatically
        -- {"BufWritePost",[[$VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw]]};
        --{ "BufWritePre", "$MYVIMRC", "lua require('core.utils').ReloadConfig()" },
    },
    general_settings = {
        { "Filetype", "qf,help,man,lspinfo", ":nnoremap <silent> <buffer> q :close<CR>" },
        { "Filetype", "qf", ":set nobuflisted" },
    },
    -- https://www.reddit.com/r/vim/comments/4aab93/comment/d0yo622/
    autoquickfix = {
        { "QuickFixCmdPost", "]^l]*", "cwindow" },
        { "QuickFixCmdPost", "l*", "lwindow" },
    },
    -- wrap_spell = {
    --     { "FileType", "markdown", ":setlocal wrap" },
    --     { "FileType", "markdown", ":setlocal spell" },
    -- },
    fix_commentstring = {
        { "Bufenter", "*config,*rc,*conf", "set commentstring=#%s" },
    },
    reload_sxhkd_bindings = {
        {'BufWritePost', '*sxhkdrc', '!pkill -USR1 sxhkd'},
        -- {'BufWritePost', '*bspwmrc', '!bspc wm -r; dunstify "bspwm restarted!"'},
    },
    make_scripts_executable = {
        {'BufWritePost', '*.sh', [[!chmod +x %]]},
        {'BufWritePost', '*.py', [[!chmod +x %]]},
    },
    custom_updates = {
        {"BufRead,BufNewFile", "Xresources,Xdefaults,xresources,xdefaults", "set filetype=xdefaults"},
        {"BufWritePost", "Xresources,Xdefaults,xresources,xdefaults", "!xrdb %"},
        {'BufWritePost', 'fonts.conf', '!fc-cache'},
        {'BufWritePost', 'config.py', '!python -m py_compile ~/.config/qtile/config.py'},
    },
    -- https://stackoverflow.com/a/23326474/2571881
    format_options = { -- :h fo-talbe (for help)
        { "BufWinEnter,BufRead,BufNewFile", "*", "setlocal formatoptions-=r formatoptions-=o" },
    },
    change_header = {
         { "BufWritePre", "*", "lua require('core.utils').changeheader()" },
    },
    resize_windows_proportionally = {
        { "VimResized", "*", ":wincmd =" };
	{ "Filetype", "help", ":wincmd =" };
    };
    packer = {
        { "BufWritePost", "plugins.lua", "source <afile> | PackerCompile" },
    },
    terminal_job = {
        { "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] },
        { "TermOpen", "*", [[tnoremap <buffer> <leader>x <c-\><c-n>:bd!<cr>]] },
        { "TermOpen", "*", [[tnoremap <expr> <A-r> '<c-\><c-n>"'.nr2char(getchar()).'pi' ]] },
        { "TermOpen", "*", "startinsert" },
        { "TermOpen", "*", [[nnoremap <buffer> <C-c> i<C-c>]] },
        { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" },
    },
    restore_cursor = {
        { "BufRead", "*", [[call setpos(".", getpos("'\""))]] },
    },

    -- https://vi.stackexchange.com/a/25687/7339
    -- hicurrent_word = {
    --     { "CursorHold", "*", [[:exec 'match Search /\V\<' . expand('<cword>') . '\>/']] },
    -- },
    -- save_shada = {
    --     -- { "VimLeave", "*", "wshada!"};
    --     { "CursorHold", "*", [[rshada|wshada]]};
    -- };
    -- auto_exit_insertmode = {
    --     { "CursorHoldI", "*", "stopinsert" },
    -- },
    wins = {
        { "VimResized", "*", ":wincmd =" },
        { "WinEnter", "*", "wincmd =" },
        { "BufEnter", "NvimTree", [[setlocal cursorline]] },
    },
    toggle_search_highlighting = {
        { "InsertEnter", "*", "setlocal nohlsearch" },
    },
    lua_highlight = {
        { "TextYankPost", "*", [[silent! lua vim.highlight.on_yank() {higroup="IncSearch", timeout=600}]] },
    },
    auto_working_directory = {
        { "BufEnter", "*", "silent! lcd %:p:h" },
    },
    clean_trailing_spaces = {
        --{ "BufWritePre", "*", [[lua require("core.utils").preserve('%s/\\s\\+$//ge')]] },
        { "BufWritePre", "*", ":%s/\\s\\+$//e" },
        { "BufWritePre", "*", "%s/\\n\\+\\%$//e" },
        { "BufWritePre", "*.[ch]", "%s/\\%$/\r/e"},

    },
    -- ansi_esc_log = {
    --     { "BufEnter", "*.log", ":AnsiEsc" };
    -- };

    -- https://stackoverflow.com/a/18427760/2571881
    -- https://vimhelp.org/usr_11.txt.html
    -- https://ttm.github.io/research/2017/11/02/vim-swp-swo.html
    -- AutoRecoverSwapFile = {
    --     { "SwapExists", "*", [[let v:swapchoice = 'r' | let b:swapname = v:swapname]] },
    --     { "BufWinEnter", "*", [[if exists("b:swapname") | call delete(b:swapname) | endif]] },
    -- },
    flash_cursor_line = {
        { "WinEnter", "*", "lua require('core.utils').flash_cursorline()" },
        -- { "WinEnter", "*", "Beacon" },
        -- { "VimEnter", "diary.md", "0put=strftime('%c')" },
    },
    -- attatch_colorizer = {
    -- 	{BufReadPost *.conf setl ft=conf};
    -- 	{"BufReadPost", "config", "setl ft=conf"};
    -- 	{"FileType", "conf", "ColorizerAttachToBuffer<CR>"};
    -- };
}

-- vim.cmd [[
-- "Auto-deletes all trailing whitespace and newlines at EOF on save & resets cursor position
--   autocmd BufWritePre * let currPos = getpos(".")
--   autocmd BufWritePre * %s/\s\+$//e
--   autocmd BufWritePre * %s/\n\+\%$//e
--   autocmd BufWritePre *.[ch] %s/\%$/\r/e
--   autocmd BufWritePre * cal cursor(currPos[1], currPos[2])
-- ]]

nvim_create_augroups(autocmds)
-- autocommands END
