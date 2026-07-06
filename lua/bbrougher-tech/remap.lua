vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "-", vim.cmd.Ex)

local formatter_precedence_by_filetype = {
    javascript = { "null-ls" },
    javascriptreact = { "null-ls" },
    typescript = { "null-ls" },
    typescriptreact = { "null-ls" },
    vue = { "null-ls" },
    css = { "null-ls" },
    scss = { "null-ls" },
    less = { "null-ls" },
    html = { "null-ls" },
    json = { "null-ls" },
    jsonc = { "null-ls" },
    yaml = { "null-ls" },
    markdown = { "null-ls" },
    ["markdown.mdx"] = { "null-ls" },
    graphql = { "null-ls" },
    handlebars = { "null-ls" },
    xml = { "null-ls" },
}

local function formatter_filter_for_filetype(filetype)
    local preferred_clients = formatter_precedence_by_filetype[filetype]
    if not preferred_clients then
        return nil
    end

    local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, preferred_client in ipairs(preferred_clients) do
        for _, client in ipairs(attached_clients) do
            if client.name == preferred_client then
                return function(format_client)
                    return format_client.name == preferred_client
                end
            end
        end
    end

    return nil
end

vim.keymap.set("n", "<leader>f", function()
    local filter = formatter_filter_for_filetype(vim.bo.filetype)

    vim.lsp.buf.format({
        filter = filter,
        timeout_ms = 2000,
    })
end)
vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float({ scope = "line", source = true })
end)

vim.keymap.set("n", "<leader>o", "o<Esc>")
vim.keymap.set("n", "<leader>O", "O<Esc>")

vim.keymap.set("n", "<leader>wvs", function()
    vim.cmd(":vertical split")
    vim.cmd(":vertical wincmd =")
end)
vim.keymap.set("n", "<leader>whs", function()
    vim.cmd(":horizontal split")
    vim.cmd(":horizontal wincmd =")
end)
vim.keymap.set("n", "<leader>wc", ":close<CR>")
vim.keymap.set("n", "<leader>wj", "<C-w>j")
vim.keymap.set("n", "<leader>wk", "<C-w>k")
vim.keymap.set("n", "<leader>wl", "<C-w>l")
vim.keymap.set("n", "<leader>wh", "<C-w>h")

vim.keymap.set("n", "<leader>wff", function()
    local currentFileName = vim.fn.expand("%:t")
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, col + 1, row - 1, col + 1, { currentFileName })
    vim.api.nvim_win_set_cursor(0, { row, col + currentFileName:len() + 1 })
end)

vim.keymap.set("n", "<leader>wfn", function()
    local currentFileName = vim.fn.expand("%:t:r")
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, col + 1, row - 1, col + 1, { currentFileName })
    vim.api.nvim_win_set_cursor(0, { row, col + currentFileName:len() + 1 })
end)

vim.keymap.set("n", "<leader>rn", function()
    local old_path = vim.fn.expand("%:p")
    if old_path == "" then
        vim.notify("No file to rename", vim.log.levels.WARN)
        return
    end

    vim.ui.input({ prompt = "Rename file: ", default = old_path, completion = "file" }, function(new_path)
        if not new_path or new_path == "" or new_path == old_path then
            return
        end

        new_path = vim.fn.fnamemodify(new_path, ":p")
        vim.fn.mkdir(vim.fn.fnamemodify(new_path, ":h"), "p")

        local ok, err = os.rename(old_path, new_path)
        if not ok then
            vim.notify("Rename failed: " .. tostring(err), vim.log.levels.ERROR)
            return
        end

        local old_buf = vim.api.nvim_get_current_buf()
        vim.cmd("edit " .. vim.fn.fnameescape(new_path))
        vim.api.nvim_buf_delete(old_buf, { force = true })
    end)
end)

vim.keymap.set("n", "<leader>df", function()
    local confirm = vim.fn.confirm("Delete buffer and file?", "&Yes\n&No", 2)

    if confirm == 1 then
        os.remove(vim.fn.expand("%"))
        vim.api.nvim_buf_delete(0, { force = true })
    end
end)

vim.keymap.set("n", "<leader>sc", ":setlocal spell!<CR>")

vim.keymap.set("n", "<leader>sa", ":ASToggle<CR>")

vim.keymap.set("n", "<m-n>", ":tabnew<CR>")
vim.keymap.set("n", "<m-c>", ":tabclose<CR>")
vim.keymap.set("n", "<m-1>", ":tabn1<CR>")
vim.keymap.set("n", "<m-2>", ":tabn2<CR>")
vim.keymap.set("n", "<m-3>", ":tabn3<CR>")
vim.keymap.set("n", "<m-4>", ":tabn4<CR>")
vim.keymap.set("n", "<m-5>", ":tabn5<CR>")
vim.keymap.set("n", "<m-6>", ":tabn6<CR>")
vim.keymap.set("n", "<m-7>", ":tabn7<CR>")
vim.keymap.set("n", "<m-8>", ":tabn8<CR>")
vim.keymap.set("n", "<m-9>", ":tabn9<CR>")

vim.keymap.set("n", "C-[", "<esc>")

vim.keymap.set("n", "<C-j>", ":cnext<CR>")
vim.keymap.set("n", "<C-k>", ":cprev<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("n", "Q", "<nop>")

-- Copilot Commands
vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>")
vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>")
