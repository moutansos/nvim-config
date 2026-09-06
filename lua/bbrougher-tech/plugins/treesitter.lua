vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
        vim.treesitter.language.register("c_sharp", "csx")
    end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.razor", "*.cshtml" },
    callback = function()
        vim.bo.filetype = "razor"
    end,
})

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        -- The `main` branch does not support lazy-loading.
        lazy = false,
        config = function()
            -- Parser names, not filetypes. `:TSInstall <Tab>` lists them all.
            require("nvim-treesitter").install({
                "bash",
                "blade",
                "c",
                "c_sharp",
                "css",
                "go",
                "gosum",
                "html",
                "http",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "php",
                "query",
                "regex",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
            })

            -- Highlighting is opt-in on the `main` branch: Neovim provides it,
            -- the plugin only ships parsers and queries. Start it for every
            -- buffer whose language has a parser available.
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
}
