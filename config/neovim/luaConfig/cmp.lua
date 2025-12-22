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
-- only show 5 options in popup menu
vim.opt.pumheight = 5
