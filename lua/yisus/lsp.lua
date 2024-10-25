local lsp_zero = require('lsp-zero')
local fidget = require('fidget')

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>lf", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>ra", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>ft", function()
        if client.name == "rust_analyzer" then
            vim.cmd(":RustFmt")
        else
            vim.lsp.buf.format({
                timeout_ms = 10000
            })
        end
    end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    if vim.lsp.inlay_hint then
        fidget.notify("Inlay hints enabled.")
        vim.lsp.inlay_hint.enable(true, { 0 })
    end
end)

lsp_zero.set_sign_icons({
    error = '󰂭',
    warn = '',
    hint = '',
    info = ''
})

require 'mason'.setup({})
require 'mason-lspconfig'.setup({
    handlers = {
        lsp_zero.default_setup
    }
})

lsp_zero.setup_servers({ 'lua_ls', 'rust_analyzer', 'clangd', 'ts_ls' })

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})