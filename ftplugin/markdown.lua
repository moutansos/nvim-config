local function replaceInLine(lineNum)
    local cursorCol = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_buf_get_lines(0, lineNum - 1, lineNum, false)[1]
    if line:find("%[%s%]") ~= nil then
        --replace with checked markdown
        local replacedString = string.gsub(line, "%[%s%]", "[x]")
        -- print("Replaced string at " .. line .. ": " .. replacedString)
        vim.api.nvim_win_set_cursor(0, {lineNum, cursorCol})
        vim.api.nvim_set_current_line(replacedString)
    elseif line:find("%[%-%]") ~= nil then
        --replace with checked markdown
        local replacedString = string.gsub(line, "%[%-%]", "[x]")
        -- print("Replaced string at " .. line .. ": " .. replacedString)
        vim.api.nvim_win_set_cursor(0, {lineNum, cursorCol})
        vim.api.nvim_set_current_line(replacedString)
    elseif line:find("%[x%]") ~= nil then
        --replace with unchecked markdown
        local replacedString = string.gsub(line, "%[x%]", "[ ]")
        -- print("Replaced string at " .. line .. ": " .. replacedString)
        vim.api.nvim_win_set_cursor(0, {lineNum, cursorCol})
        vim.api.nvim_set_current_line(replacedString)
    end
end

vim.keymap.set("n", "<leader>x", function()
    local lineNum = vim.api.nvim_win_get_cursor(0)[1]
    replaceInLine(lineNum)
end)

vim.keymap.set("v", "<leader>x", function()
    local line_start = vim.fn.line("v")
    local line_end = vim.fn.line(".")

    if line_start > line_end then
        line_start, line_end = line_end, line_start
    end

    -- print("Line start: " .. line_start)
    -- print("Line end: " .. line_end)

    for _, lineNum in ipairs(vim.fn.range(line_start, line_end)) do
        replaceInLine(lineNum)
    end
end)

local os_name = vim.loop.os_uname().sysname

if os_name == "Windows_NT" then
    vim.keymap.set("n", "<leader>of", ":!start <cfile><CR>", { silent = true })
elseif os_name == "Linux" then
    -- Linux-specific configuration
elseif os_name == "Darwin" then
    -- macOS-specific configuration
end


vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*.md",
    callback = function()
        vim.fn.matchadd("Todo", "TODO")
        vim.fn.matchadd("Error", "BUG")
    end,
})
