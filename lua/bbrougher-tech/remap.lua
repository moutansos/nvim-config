vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "-", vim.cmd.Ex)
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({
        filter = function(client)
            return client.name ~= "tsserver"
        end,
        timeout_ms = 2000,
    })
end)
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
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

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set(
    "v",
    "<C-c>",
    "y:!echo <C-r>=escape(substitute(shellescape(getreg('\"')), '\\n', '\\r', 'g'), '#%!')<CR> <Bar> clip.exe<CR><CR>"
)

vim.keymap.set("i", "ii", "<ESC>")

vim.keymap.set("n", "Q", "<nop>")
