vim.keymap.set("n", "<leader>sl", function()
    vim.api.nvim_put({"Console.WriteLine();"}, "", true, true)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_win_set_cursor(0, { row, col - 1 })
    vim.cmd("startinsert")
end)

