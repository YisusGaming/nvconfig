require 'nvterm'.setup({
    terminals = {
        shell = 'bash',
        type_opts = {
            float = {
                row = 0.1,
                col = 0.1,
                width = 0.8,
                height = 0.7
            }
        }
    }
})

local termial = require("nvterm.terminal")

vim.keymap.set("n", "<leader>m", function() termial.toggle('float') end)
vim.keymap.set("t", "<leader>m", function() termial.toggle('float') end)
