vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>tn", vim.cmd.tabnew)
vim.keymap.set("n", "<leader>x", vim.cmd.tabclose)
vim.keymap.set("n", "<Tab>", vim.cmd.tabnext);
vim.keymap.set("n", "<S-Tab>", vim.cmd.tabprevious)

vim.keymap.set("n", "<C-n>", vim.cmd.NvimTreeToggle)
