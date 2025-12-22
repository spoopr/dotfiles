-- show lsp messages
vim.diagnostic.config({
    virtual_text = true,
})

-- setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- -- enable all the servers
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
