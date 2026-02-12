return {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
        { "<leader>gaa", ":Git add .<CR>", desc = "Git Add All Files" },
        { "<leader>gat", ":Git add %<CR>", desc = "Git Add This File" },
    },
}
