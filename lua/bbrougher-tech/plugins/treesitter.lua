vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
        vim.treesitter.language.register("c_sharp", "csx")
    end,
})

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = false,
    },
}
