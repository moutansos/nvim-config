vim.keymap.set("n", "<leader>smt", function()
    local line = vim.api.nvim_get_current_line()
    if (line:find("%[%s%]") ~= nil) then
        --replace with checked markdown
        local replacedString = string.gsub(line, "%[%s%]", "[x]")
        print("Replaced string: " .. replacedString)
        vim.api.nvim_set_current_line(replacedString)
    elseif (line:find("%[x%]") ~= nil) then
        --replace with unchecked markdown
        local replacedString = string.gsub(line, "%[x%]", "[ ]")
        print("Replaced string: " .. replacedString)
        vim.api.nvim_set_current_line(replacedString)
    end
end)
