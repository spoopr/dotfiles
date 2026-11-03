-- -- treesitter-based folding
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'
-- -- -- don't motherfucking fold everything on open
vim.opt.foldlevel = 99

vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "*",
        callback = function ()
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    }
)
