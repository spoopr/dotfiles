-- line numbers
vim.opt.number = true

-- tab width
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- -- do convert tabs
vim.opt.expandtab = true

-- setup ruler at 80 chars wide
vim.opt.textwidth = 80
vim.opt.colorcolumn = "81";


-- keep diagnostics gutter open
vim.opt.signcolumn = "yes"

-- keep cursor away from the edges of the screen
vim.opt.scrolloff = 15

-- don't softwrap
vim.opt.wrap = false

-- highlight trailing whitespace
vim.cmd 'match ExtraWhitespace /\\s\\+$/'
vim.api.nvim_set_hl(
    0,
    "ExtraWhitespace",
    {
        fg = "NvimLightRed",
        underline = true
    }
)
-- show highlights only in normal mode
vim.api.nvim_create_autocmd(
    'InsertEnter',
    {
        callback = function()
            vim.cmd.hi("clear ExtraWhitespace")
        end,
        pattern = '*'
    }
)
vim.api.nvim_create_autocmd(
    'InsertLeave',
    {
        callback = function()
            vim.cmd.hi("ExtraWhitespace guifg=NvimLightRed gui=underline")
        end,
        pattern = '*'
    }
)

