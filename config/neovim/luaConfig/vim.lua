-- line numbers
vim.opt.number = true

-- tab width
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- -- do convert tabs
vim.opt.expandtab = true

-- mark all text beyond 80 characters wide
vim.cmd 'highlight ColorColumn guifg=NvimDarkGrey4 guibg=NONE'
vim.cmd "call matchadd('ColorColumn', '\\%>80v', 100)"

-- keep diagnostics gutter open
vim.opt.signcolumn = "yes"
