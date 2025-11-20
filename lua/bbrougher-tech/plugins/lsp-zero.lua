return {
    "mason-org/mason-lspconfig.nvim",
    opt = {
        ensure_installed = {
            "rust_analyzer",
            "yamlls",
            "jsonls",
            "lua_ls",
        },
        automatic_enable = true,
    },
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {},
        },
        "neovim/nvim-lspconfig",
        {
            "hrsh7th/nvim-cmp",
            opts = function()
                local cmp = require("cmp")
                return {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                        --vim.snippet.expand(args.body) -- TODO: Try this later
                    end,
                    window = {
                        completion = cmp.config.window.bordered(),
                        documentation = cmp.config.window.bordered(),
                    },
                    mapping = {
                        ["<Tab>"] = nil,
                        ["<S-Tab>"] = nil,
                        ["<C-p>"] = cmp.mapping.select_prev_item(),
                        ["<C-n>"] = cmp.mapping.select_next_item(),
                        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                        ["<C-y>"] = cmp.mapping.confirm({
                            select = true,
                            behavior = cmp.ConfirmBehavior.Replace,
                        }),
                        ["<C-Space>"] = cmp.mapping.complete(),
                    },
                    sources = {
                        { name = "nvim_lsp" },
                        { name = "path" },
                        { name = "buffer" },
                        { name = "luasnip" },
                        { name = "lazydev", group_index = 0 },
                        -- { name = "cmdline" },
                    },
                }
            end,
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-cmdline",
                "L3MON4D3/LuaSnip",
            },
        },
    },
}
