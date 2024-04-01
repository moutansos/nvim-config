vim.keymap.set("n", "<leader>sl", function()
    vim.api.nvim_put({"fmt.Println()"}, "", true, true)
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd("startinsert")
end)

