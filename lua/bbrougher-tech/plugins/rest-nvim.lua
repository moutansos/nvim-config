return {
    "rest-nvim/rest.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "http")
        end,
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
    enabled = function()
        return jit.os == "Linux"
    end,
}
