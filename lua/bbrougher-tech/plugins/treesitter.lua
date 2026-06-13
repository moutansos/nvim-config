vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
        vim.treesitter.language.register("c_sharp", "csx")
    end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.razor", "*.cshtml"},
  callback = function()
    vim.bo.filetype = "razor"
  end,
})

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = false,
        main = "nvim-treesitter",
        opts = {
            install_dir = vim.fn.stdpath("data") .. "/site",
        },
    },
}
