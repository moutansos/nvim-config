vim.keymap.set("n", "<leader>sl", function()
    vim.api.nvim_put({"Console.WriteLine();"}, "", true, true)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_win_set_cursor(0, { row, col - 1 })
    vim.cmd("startinsert")
end)

local function getNamespaceForCurrentBuffer()
    local currentFile = vim.fn.expand("%:.:r")

    -- This worked on linux. Not windows. May have to switch on OS
    --local currentFile = vim.fn.expand("%:.:r")

    local namespaceName = currentFile:gsub("%\\", "."):gsub("%/", ".")
    return namespaceName
end

local function getTypeNameFromCurrentFile()
    local currentFile = vim.fn.expand("%:t:r")
    return currentFile
end


vim.keymap.set("n", "<leader>gmc", function()
    local namespace = getNamespaceForCurrentBuffer()
    local name = getTypeNameFromCurrentFile()
    local classTemplate = {
        "namespace " .. namespace ..";",
        "",
        "public class " .. name,
        "{",
        "    ",
        -- "",
        -- "    public ".. name .. "()",
        -- "    {",
        -- "    }",
        "}"
    }

    local row, column = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, 0, 0, false, classTemplate)
    vim.api.nvim_win_set_cursor(0, { row + 4, column })
    vim.api.nvim_feedkeys("A", "n", false)
end)

vim.keymap.set("n", "<leader>gcc", function()
    local namespace = getNamespaceForCurrentBuffer()
    local name = getTypeNameFromCurrentFile()
    local classTemplate = {
        "namespace " .. namespace,
        "{",
        "    public class " .. name,
        "    {",
        "        ",
        -- "",
        -- "    public ".. name .. "()",
        -- "    {",
        -- "    }",
        "    }",
        "}"
    }

    local row, column = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, 0, 0, false, classTemplate)
    vim.api.nvim_win_set_cursor(0, { row + 4, column })
    vim.api.nvim_feedkeys("A", "n", false)
end)

vim.keymap.set("n", "<leader>gr", function()
    local namespace = getNamespaceForCurrentBuffer()
    local name = getTypeNameFromCurrentFile()
    local classTemplate = {
        "namespace " .. namespace ..";",
        "",
        "public record " .. name .. "();",
    }

    local row, column = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, 0, 0, false, classTemplate)
    vim.api.nvim_win_set_cursor(0, { row + 2, 24 })
    vim.api.nvim_feedkeys("i", "n", false)
end)

vim.keymap.set("n", "<leader>gms", function()
    local namespace = getNamespaceForCurrentBuffer()
    local name = getTypeNameFromCurrentFile()
    local classTemplate = {
        "namespace " .. namespace ..";",
        "public interface I" .. name,
        "{",
        "}",
        "",
        "public class " .. name .. " : I" .. name,
        "{",
        "    ",
        -- "",
        -- "    public ".. name .. "()",
        -- "    {",
        -- "    }",
        "}"
    }

    local row, column = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, 0, 0, false, classTemplate)
    vim.api.nvim_win_set_cursor(0, { row + 7, column })
    vim.api.nvim_feedkeys("A", "n", false)
end)

vim.keymap.set("n", "<leader>gcs", function()
    local namespace = getNamespaceForCurrentBuffer()
    local name = getTypeNameFromCurrentFile()
    local classTemplate = {
        "namespace " .. namespace,
        "{",
        "    public interface I" .. name,
        "    {",
        "    }",
        "",
        "    public class " .. name .. " : I" .. name,
        "    {",
        "        ",
        -- "",
        -- "    public ".. name .. "()",
        -- "    {",
        -- "    }",
        "    }",
        "}"
    }

    local row, column = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, 0, 0, false, classTemplate)
    vim.api.nvim_win_set_cursor(0, { row + 8, column })
    vim.api.nvim_feedkeys("A", "n", false)
end)

vim.keymap.set("n", "<leader>gcf", function()
    local namespace = getNamespaceForCurrentBuffer()
    local name = getTypeNameFromCurrentFile()
    local classTemplate = {
        "namespace " .. namespace,
        "{",
        "    ",
        "}"
    }

    local row, column = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, 0, 0, false, classTemplate)
    vim.api.nvim_win_set_cursor(0, { row + 2, column })
    vim.api.nvim_feedkeys("A", "n", false)
end)

vim.keymap.set("n", "<leader>gmf", function()
    local namespace = getNamespaceForCurrentBuffer()
    local name = getTypeNameFromCurrentFile()
    local classTemplate = {
        "namespace " .. namespace .. ";",
        "",
        ""
    }

    local row, column = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, 0, 0, false, classTemplate)
    vim.api.nvim_win_set_cursor(0, { row + 2, column })
    vim.api.nvim_feedkeys("A", "n", false)
end)
