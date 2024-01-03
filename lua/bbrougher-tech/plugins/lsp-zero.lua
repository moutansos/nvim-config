return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
        -- LSP Support
        { "neovim/nvim-lspconfig" }, -- Required
        { -- Optional
            "williamboman/mason.nvim",
            build = function()
                pcall(vim.cmd, "MasonUpdate")
            end,
            config = function()
                require("mason").setup({})
            end,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            config = function() end,
        }, -- Optional

        -- Autocompletion
        { "hrsh7th/nvim-cmp" }, -- Required
        { "hrsh7th/cmp-nvim-lsp" }, -- Required
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-buffer" },
        { "L3MON4D3/LuaSnip" }, -- Required
        { "saadparwaiz1/cmp_luasnip" },
    },
}
