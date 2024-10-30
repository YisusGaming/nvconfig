local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<leader>di', builtin.diagnostics, {})
            vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
        end
    },
    { "catppuccin/nvim", name = "catppuccin" },
    {
        'nvim-treesitter/nvim-treesitter',
        opts = {
            -- A list of parser names, or "all" (the five listed parsers should always be installed)
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            highlight = {
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
        },
        config = function()
            vim.cmd.TSEnable("highlight")
        end
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        event = "VeryLazy",
        config = function()
            require 'yisus.lsp'
        end,
        branch = 'v3.x',
        dependencies = {
            --- Uncomment these if you want to manage LSP servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = 'auto'
            }
        }
    },
    { "NvChad/nvterm" },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
    },
    { 'nvim-tree/nvim-web-devicons' },
    {
        lazy = true,
        'j-hui/fidget.nvim',
        opts = {}
    },
    {
        'simrat39/rust-tools.nvim',
        lazy = true,
        ft = "rust",
        config = function()
            local rt = require("rust-tools")

            rt.setup({
                server = {
                    on_attach = function(_, bufnr)
                        -- Hover actions
                        vim.keymap.set("n", "<leader>a", rt.hover_actions.hover_actions, { buffer = bufnr })
                    end,
                },
                tools = {
                    hover_actions = {
                        auto_focus = true,
                    },
                },
            })
        end
    },
    {
        "folke/todo-comments.nvim",
        config = function()
            require 'todo-comments'.setup()

            vim.keymap.set("n", "<leader>td", vim.cmd.TodoTelescope)
        end,
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        cmd = { "DapContinue", "DapToggleBreakpoint" },
        dependencies = { "rcarriga/nvim-dap-ui" },
    },
    {
        lazy = true,
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },
    {
        'nanozuki/tabby.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
    },
    {
        "rbong/vim-flog",
        lazy = true,
        cmd = { "Flog", "Flogsplit", "Floggit" },
        dependencies = {
            "tpope/vim-fugitive",
        },
    },
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            require("ibl").setup()
        end
    }
}

require("lazy").setup(plugins, { concurrency = 2 })
