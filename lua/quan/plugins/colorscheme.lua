return {
  'morhetz/gruvbox',
  priority = 1000,
  config = function()
    vim.opt.background = "dark"
    vim.cmd([[colorscheme gruvbox]])
  end,
}
