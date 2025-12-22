require('nvim-treesitter.configs').setup({
	highlight = {
		enable = true,
	},
})

-- -- treesitter-based folding
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'
-- -- -- don't motherfucking fold everything on open
vim.opt.foldlevel = 99
