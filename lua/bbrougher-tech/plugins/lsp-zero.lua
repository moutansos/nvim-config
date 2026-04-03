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
        {
            "neovim/nvim-lspconfig",
            keys = {
                { "<leader>lsr", "<cmd>LspRestart<cr>", desc = "Restart LSP" },
            },
        },
        {
            "hrsh7th/nvim-cmp",
            opts = function()
                local cmp = require("cmp")
                local lspkind = require("lspkind")
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
                    formatting = {
                        fields = { "abbr", "icon", "kind", "menu" },
                        format = lspkind.cmp_format({
                            maxwidth = {
                                menu = 50, -- leading text (labelDetails)
                                abbr = 50, -- actual suggestion item
                            },
                            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                            show_labelDetails = true, -- show labelDetails in menu. Disabled by defaul
                            -- The function below will be called before any actual modifications from lspkind
                            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                            before = function(entry, vim_item)
                                return vim_item
                            end,
                            menu = {
                                nvim_lsp = "[LSP]",
                                path = "[Path]",
                                buffer = "[Buffer]",
                                luasnip = "[LuaSnip]",
                                lazydev = "[LazyDev]",
                                cmdline = "[CmdLine]",
                            }
                        }),
                    },
                }
            end,
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-cmdline",
                "L3MON4D3/LuaSnip",
                "onsails/lspkind.nvim",
            },
        },
    },
}
