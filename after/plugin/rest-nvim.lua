vim.keymap.set('n', '<leader>rr', '<cmd>lua require("rest-nvim").run()<CR>', { noremap = true })
vim.keymap.set('n', '<leader>rp', '<cmd>lua require("rest-nvim").run(true)<CR>', { noremap = true })
vim.keymap.set('n', '<leader>rl', '<Plug>RestNvimLast<CR>', { noremap = true })
