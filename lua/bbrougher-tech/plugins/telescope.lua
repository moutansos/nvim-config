local telescopeConfig = {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        {
            "<C-p>",
            function()
                require("telescope.builtin").git_files()
            end,
            mode = { "n", "i" },
        },
        {
            "<leader>pf",
            function()
                require("telescope.builtin").find_files()
            end,
        },
        {
            "<leader>pg",
            function()
                require("telescope.builtin").live_grep()
            end,
        },
        {
            "<leader>ps",
            function()
                require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
            end,
        },
        {
            "<leader>vh",
            function()
                require("telescope.builtin").help_tags()
            end,
        },
        {
            "<leader>csd",
            function()
            end
        }
    },
    config = function()
        require("telescope").setup({
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                },
            },
        })

    end,
}

return telescopeConfig
