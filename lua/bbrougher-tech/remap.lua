vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>f", ":Neoformat<CR>")
vim.keymap.set("n", "C-[", "<esc>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<C-c>", "y:!echo <C-r>=escape(substitute(shellescape(getreg(\'\"\')), \'\\n\', \'\\r\', \'g\'), \'#%!\')<CR> <Bar> clip.exe<CR><CR>")

vim.keymap.set("i", "ii", "<ESC>")

vim.keymap.set("n", "Q", "<nop>")
