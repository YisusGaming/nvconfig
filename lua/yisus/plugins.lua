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
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        priority = 1000,
        opts = require 'yisus.configs.catppuccin',
        config = function()
            vim.cmd.colorscheme "catppuccin"
        end
    },
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require 'nightfox'.setup(require 'yisus.configs.nightfox')
            vim.cmd.colorscheme "duskfox"
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = require 'yisus.configs.telescope'
    },
    {
        'nvim-treesitter/nvim-treesitter',
        opts = require 'yisus.configs.treesitter',
        config = function()
            vim.cmd.TSEnable("highlight")
        end
    },

    {
        'neovim/nvim-lspconfig',
        lazy = true,
        config = function()
            require 'yisus.lsp'
        end,
        keys = { { "<leader>l", "<cmd>e<cr>", desc = "Load LSP" } },
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
        }
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = require 'yisus.configs.lualine'
    },
    {
        "NvChad/nvterm",
        config = function()
            require 'nvterm'.setup(require 'yisus.configs.nvterm')
            local terminal = require 'nvterm.terminal'

            vim.keymap.set("n", "<A-0>", function() terminal.toggle('float') end)
            vim.keymap.set("t", "<A-0>", function() terminal.toggle('float') end)
        end
    },
    {
        'nvim-tree/nvim-tree.lua',
        lazy = true,
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
        "folke/todo-comments.nvim",
        event        = "BufEnter",
        lazy         = true,
        config       = function()
            require 'todo-comments'.setup()

            vim.keymap.set("n", "<leader>td", vim.cmd.TodoTelescope)
        end,
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        'nanozuki/tabby.nvim',
        opts = require 'yisus.configs.tabby',
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
}

require("lazy").setup(plugins, { concurrency = 2 })
