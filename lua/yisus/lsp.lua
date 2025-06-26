local fidget = require('fidget')

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local opts = { buffer = args.buf, remap = false }
        vim.lsp.config("*", {
            capabilities = { workspace = { didChangeWatchedFiles = { dynamicRegistration = false } } }
        })

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>lf", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>ra", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>ft", function() vim.lsp.buf.format({ timeout_ms = 10000 }) end, opts)

        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

        if vim.lsp.inlay_hint then
            fidget.notify("Inlay hints enabled.")
            vim.lsp.inlay_hint.enable(true, { 0 })
        end

        vim.diagnostic.config({
            virtual_lines = {
                format = function(diagnostic)
                    local headers = {
                        [vim.diagnostic.severity.ERROR] = '',
                        [vim.diagnostic.severity.WARN] = '',
                        [vim.diagnostic.severity.INFO] = '',
                        [vim.diagnostic.severity.HINT] = '',
                    }

                    return string.format("%s %s", headers[diagnostic.severity], diagnostic.message)
                end,
                current_line = true,
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '',
                    [vim.diagnostic.severity.WARN] = '',
                    [vim.diagnostic.severity.INFO] = '',
                    [vim.diagnostic.severity.HINT] = '',
                },
                numhl = {
                    [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
                    [vim.diagnostic.severity.WARN] = 'WarningMsg',
                    [vim.diagnostic.severity.INFO] = 'InfoMsg',
                    [vim.diagnostic.severity.HINT] = 'HintMsg',
                }
            }
        })
    end
})

require 'mason'.setup({})
require 'mason-lspconfig'.setup({
    automatic_enable = true
})

local servers = { 'lua_ls', 'rust_analyzer', 'clangd', 'ts_ls', 'csharp_ls', 'zls' }
vim.lsp.enable(servers)

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }
    })
})

local cmp_capabilities = require 'cmp_nvim_lsp'.default_capabilities()
for _, s in ipairs(servers) do
    vim.lsp.config(s, {
        capabilities = cmp_capabilities
    })
end
