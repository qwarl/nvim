vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- auto format
vim.g.autoformat = true

local opt = vim.opt

opt.autoindent = true
opt.autowrite = true -- autosave before do something
opt.breakindent = true -- keep indent for wrapped lines
opt.clipboard = "unnamedplus"
opt.conceallevel = 2 -- hide * markup for bol and italic, but not markers with substitutions
opt.confirm = true -- confirm to save changes before existing modified bufer
opt.cursorline = true -- highlight the current line
opt.expandtab = true -- use spaces instead of tabs
opt.ignorecase = true -- searching text regardless uppercase or lowercase
opt.linebreak = true -- enable line breaks at word boundaries
opt.mouse = "a" -- allow mouse
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 2
opt.signcolumn = "yes" -- vertical column on the left side that displays signs such as error or warning indicators
opt.smartcase = true -- don't ignore case with capitals
opt.smartindent = true -- indent but for code
opt.splitbelow = true -- new windows below current
opt.splitright = true -- new windows right of current
opt.tabstop = 2 -- number of spaces tabs count for
opt.termguicolors = true -- true color support
opt.wrap = true -- enable line wrapping

opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- change diagnostic symbols
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
