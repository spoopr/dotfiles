-- line numbers
vim.opt.number = true

-- tab width
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- do convert tabs
vim.opt.expandtab = true

-- mark all text beyond 80 characters wide
vim.cmd 'highlight ColorColumn guifg=NvimDarkGrey4 guibg=NONE'
vim.cmd "call matchadd('ColorColumn', '\\%>80v', 100)"

-- keep diagnostics gutter open
vim.opt.signcolumn = "yes"

-- leap
require('leap').create_default_mappings()

-- show lsp messages
vim.diagnostic.config({
    virtual_text = true,
})

-- treesitter
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

-- autocomplete
local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
	view = {
		docs = {
			auto_open = false
		}
	},
	window = {
		completion = {
			scrollbar = true
		}
	},
	mapping = {
		['<A-Tab>'] = cmp.mapping.complete(),
		['<A-k>'] = cmp.mapping(
			function()
				if cmp.visible_docs() then
					cmp.scroll_docs(-4)
				else
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
				end
			end
		),
		['<A-j>'] = cmp.mapping(
			function()
				if cmp.visible_docs() then
					cmp.scroll_docs(4)
				else
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				end
			end
		),
		['<A-l>'] = cmp.mapping.open_docs(),
		['<A-h>'] = cmp.mapping.close_docs(),
		['<A-CR>'] = cmp.mapping.confirm({ select = true }),
		['<A-Esc>'] = cmp.mapping(
			function(fallback)
				if cmp.visible_docs() then
					cmp.close_docs()
				elseif cmp.visible() then
					cmp.close()
				else
					fallback()
				end
			end
		)
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'buffer' },
	}),
})
vim.opt.pumheight = 5

-- lsp setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config("jdtls", {
	capabilities = capabilities
})
vim.lsp.enable("jdtls")

vim.lsp.config("lua_ls", {
	capabilities = capabilities
})
vim.lsp.enable("lua_ls")

vim.lsp.config("nixd", {
	capabilities = capabilities
})
vim.lsp.enable("nixd")

vim.lsp.config("ts_ls", {
	capabilities = capabilities
})
vim.lsp.enable("ts_ls")
