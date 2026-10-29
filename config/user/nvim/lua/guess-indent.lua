require('guess-indent').setup({})
-- this *should* run by default, but doesn't for some reason?
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "*",
        command = "GuessIndent"
    }
)
