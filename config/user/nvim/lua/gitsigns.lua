require('gitsigns').setup {
    signs = {
        add          = { text = '+' },
        change       = { text = '|' },
        delete       = { text = '-' },
        topdelete    = { text = '-' },
        changedelete = { text = '|' },
        untracked    = { text = ':' },
    },
    signs_staged = {
        add          = { text = '+' },
        change       = { text = '|' },
        delete       = { text = '-' },
        topdelete    = { text = '-' },
        changedelete = { text = '|' },
        untracked    = { text = ':' },
    },
    signs_staged_enable = true,
    signcolumn = true,
    numhl = true,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
        follow_files = true
    },
    auto_attach = true,
    attach_to_untracked = true,
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil -- Use default
}
