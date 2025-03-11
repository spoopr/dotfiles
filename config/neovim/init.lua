-- line numbers
vim.opt.number = true

-- tab width
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- don't convert tabs
vim.opt.expandtab = false

-- leap
require('leap').create_default_mappings()

-- treesitter
require('nvim-treesitter.configs').setup({
	highlight = {
		enable = true,
	},
})
