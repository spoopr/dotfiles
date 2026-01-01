-- show lsp messages
vim.diagnostic.config({
    virtual_text = true,
})

-- setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- -- enable all the servers
vim.lsp.config('jdtls', {
    cmd = { 'jdtls' },
	capabilities = capabilities,
    filetypes = { 'java' },
    root_markers = { '.git' },
})
vim.lsp.enable('jdtls')

vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
	capabilities = capabilities,
    filetypes = { 'lua' },
    root_markers = { '.git' },
})
vim.lsp.enable('lua_ls')

vim.lsp.config('nixd', {
    cmd = { 'nixd' },
	capabilities = capabilities,
    filetypes = { 'nix' },
    root_markers = { '.git' },
})
vim.lsp.enable('nixd')

vim.lsp.config('ts_ls', {
    cmd = { 'typescript-language-server' },
	capabilities = capabilities,
    filetypes = { 'ts' },
    root_markers = { '.git' },
})
vim.lsp.enable('ts_ls')
