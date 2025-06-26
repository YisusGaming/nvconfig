return function()
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>pf', function() builtin.find_files({ previewer = false }) end, {})
    vim.keymap.set('n', '<C-p>', function() builtin.git_files({ previewer = false }) end, {})
    vim.keymap.set('n', '<leader>di', builtin.diagnostics, {})
    vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
    vim.keymap.set('n', '<leader>th', builtin.colorscheme, {})
end
