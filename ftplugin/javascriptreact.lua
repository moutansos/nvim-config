vim.keymap.set("n", "<leader>sl", function()
    vim.api.nvim_put({"console.log();"}, "", true, true)
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, {cursor[1], cursor[2] - 1})
    vim.cmd("startinsert")
end)

