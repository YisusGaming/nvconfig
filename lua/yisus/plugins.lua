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
        lazy = false,
        priority = 1000,
        opts = require 'yisus.configs.catppuccin',
        config = function()
            vim.cmd.colorscheme "catppuccin"
        end
    },

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
    {
        'nvim-treesitter/nvim-treesitter',
        opts = require 'yisus.configs.treesitter',
        config = function()
            vim.cmd.TSEnable("highlight")
        end
    },

    {
        'neovim/nvim-lspconfig',
        event = "InsertEnter",
        config = function() require 'yisus.lsp' end,
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
        opts = {
            options = {
                theme = 'auto'
            }
        }
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
        lazy = true,
        config = function()
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
    }
}

require("lazy").setup(plugins, { concurrency = 2 })
