return {
    "rest-nvim/rest.nvim",
    dependencies = {
        -- The `http` parser is installed by the nvim-treesitter spec.
        "nvim-treesitter/nvim-treesitter",
    },
    keys = {
        {
            "<leader>rr",
            "<cmd>:Rest run<CR>",
            mode = { "n" },
            desc = "Run the rest request under the cursor",
        },
    },
    ft = { "http" },
    enabled = false,
    -- enabled = function()
    --     return jit.os == "Linux"
    -- end,
}
