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
        build = function()
            require("nvim-treesitter").update():wait(300000)
            require("nvim-treesitter").install({ "css" }):wait(300000)
        end,
        lazy = false,
        main = "nvim-treesitter",
    },
}
