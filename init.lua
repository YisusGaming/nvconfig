-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require 'yisus'
require 'yisus.plugins'

require("nvim-tree").setup {
    hijack_cursor = true,
    view = {
        side = "left",
        width = 30,
        float = {
            enable = true,
            quit_on_focus_loss = true,
            open_win_config = {
                relative = "editor",
                border = "rounded",
                width = 30,
                height = 30,
                row = 1,
                col = 1,
            },
        },
    },
    git = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        disable_for_dirs = {},
        timeout = 8000,
        cygwin_support = false,
    },
    renderer = {
        add_trailing = true,
        indent_markers = {
            enable = true
        }
    }
}
