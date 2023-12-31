local set = vim.opt

-- line numbers
set.number = true -- shows absolute line number on cursor line (when relative number is on)
set.relativenumber = true -- show relative line numbers

-- tabs & indent
set.tabstop = 2 -- 2 spaces for tabs (prettier default)
set.shiftwidth = 2 -- 2 spaces for indent width
set.expandtab = true
set.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
set.wrap = false -- disable line wrapping

-- search settings
set.ignorecase = true -- ignore case when searching
set.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
set.cursorline = true -- highlight the current cursor line

-- apprearance
set.termguicolors = true
set.background = "dark" -- colorschemes that can be light or dark will be made dark
set.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
set.backspace = "indent,eol,start"

--clipboard
set.clipboard = "unnamedplus" -- copy neovim to clipboard
-- set.clipboard:append('unnamedplus')
