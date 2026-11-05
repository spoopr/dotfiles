require("autoclose").setup({
    keys = {
        ["("] = {
            escape = false,
            close = true,
            pair = "()",
            disabled_filetypes = { "text", "markdown" }
        },
        ["["] = {
            escape = false,
            close = true,
            pair = "[]",
            disabled_filetypes = { "text", "markdown" }
        },
        ["{"] = {
            escape = false,
            close = true,
            pair = "{}",
            disabled_filetypes = { "text", "markdown" }
        },

        [">"] = {
            escape = true,
            close = false,
            pair = "<>",
            disabled_filetypes = { "text", "markdown" }
        },

        [")"] = {
            escape = true,
            close = false,
            pair = "()",
            disabled_filetypes = { "text", "markdown" }
        },
        ["]"] = {
            escape = true,
            close = false,
            pair = "[]",
            disabled_filetypes = { "text", "markdown" }
        },
        ["}"] = {
            escape = true,
            close = false,
            pair = "{}",
            disabled_filetypes = { "text", "markdown" }
        },

        ['"'] = {
            escape = true,
            close = true,
            pair = '""',
            disabled_filetypes = { "text", "markdown" }
        },
        ["'"] = {
            escape = true,
            close = true,
            pair = "''",
            disabled_filetypes = { "text", "markdown" }
        },
        ["`"] = {
            escape = true,
            close = true,
            pair = "``",
            disabled_filetypes = { "text", "markdown" }
        },
    },

    options = {
        disable_when_touch = true,
        touch_regex = "[%w(%[{|;$]",
        pair_spaces = true,
        auto_indent = true
    }
})
