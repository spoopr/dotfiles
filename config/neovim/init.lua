-- line numbers
vim.opt.number = true

-- tab width
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- do convert tabs
vim.opt.expandtab = true

-- keep diagnostics gutter open
vim.opt.signcolumn = "yes"

-- leap
require('leap').create_default_mappings()

-- treesitter
require('nvim-treesitter.configs').setup({
	highlight = {
		enable = true,
	},
})
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
local lspconfig = require('lspconfig')

lspconfig.jdtls.setup({
	capabilities = capabilities
})
lspconfig.lua_ls.setup({
	capabilities = capabilities
})
lspconfig.nixd.setup({
	capabilities = capabilities
})
lspconfig.ts_ls.setup({
	capabilities = capabilities
})
