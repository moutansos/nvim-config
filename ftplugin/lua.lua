vim.keymap.set("n", "<leader>sl", function()
    vim.api.nvim_put({ "print()" }, "", true, true)
    vim.cmd("startinsert")
end)
