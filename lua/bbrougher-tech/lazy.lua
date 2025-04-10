vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    require("bbrougher-tech.plugins.telescope"),
    require("bbrougher-tech.plugins.vscode-colors"),
    require("bbrougher-tech.plugins.treesitter"),
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/playground",
    require("bbrougher-tech.plugins.harpoon"),
    "mbbill/undotree",
    "sbdchd/neoformat",
    "ojroques/vim-oscyank",
    "ryanoasis/vim-devicons",
    -- "github/copilot.vim",
    "leoluz/nvim-dap-go",
    {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
    },
    require("bbrougher-tech.plugins.nvim-dap-ui"),
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
    "FabijanZulj/blame.nvim",
    -- require("bbrougher-tech.plugins.indent-blankline"),
    require("bbrougher-tech.plugins.neotest"),
    require("bbrougher-tech.plugins.null-ls"),
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    require("bbrougher-tech.plugins.lualine"),
    require("bbrougher-tech.plugins.lsp-zero"),
    "rafamadriz/friendly-snippets",
    {
        "Pocco81/auto-save.nvim",
        -- enabled = false,
        config = function()
            require("auto-save").setup({
                condition = function(buf)
                    local fn = vim.fn
                    local utils = require("auto-save.utils.data")

                    if vim.api.nvim_buf_is_loaded(buf) == 0 then
                        return false
                    end

                    -- don't save the harpoon menu
                    local bufName = ""
                    if pcall(function()
                            bufName = vim.api.nvim_buf_get_name(buf)
                        end) then
                        if string.match(bufName, "__harpoon.menu__") then
                            return false
                        end
                    else
                        return false
                    end

                    if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
                        return true -- met condition(s), can save
                    end
                    return false -- can't save
                end,
            })
        end,
    },
    "numToStr/Comment.nvim",
    require("bbrougher-tech.plugins.luasnip"),
    require("bbrougher-tech.plugins.cloak"),
    {
        "terrortylor/nvim-comment",
        cmd = { "CommentToggle" },
        keys = {
            {
                "gcc",
                mode = { "v" },
            },
            "gc",
        },
        config = function()
            require("nvim_comment").setup({})
        end,
    },
    {
        "ThePrimeagen/vim-apm",
        keys = {
            {
                "<leader>pm",
                function()
                    require("vim-apm").toggle_monitor()
                end,
                mode = { "n" },
            },
        },
        config = function()
            local apm = require("vim-apm")

            apm:setup({})
            vim.keymap.set("n", "<leader>pm", function()
                apm:toggle_monitor()
            end)
        end,
    },
    {
        "fabridamicelli/cronex.nvim",
        opts = {},
    },
    require("bbrougher-tech.plugins.gp"),
    -- require("bbrougher-tech.plugins.avante"),
    {
        "ricardoramirezr/blade-nav.nvim",
        dependencies = {         -- totally optional
            "hrsh7th/nvim-cmp",  -- if using nvim-cmp
        },
        ft = { "blade", "php" }, -- optional, improves startup time
        opts = {
            close_tag_on_complete = true, -- default: true
        },
    },
    {
        "stevearc/dressing.nvim",
        opts = {},
    },
    {
        -- dir = "~/source/repos/stashdown.nvim",
        -- name = "stashdown",
        "msyke/stashdown.nvim",
        config = function()
            local sd = require("stashdown")
            sd.setup()
        end,
        keys = {
            {
                "<leader>sdn",
                "<cmd>:Stashdown nf<CR>",
                mode = { "n" },
                desc = "Create a new stashdown markdonw file",
            },
            {
                "<leader>sde",
                "<cmd>:Stashdown ne<CR>",
                mode = { "n" },
                desc = "Create a new entry in the current markdown file",
            },
            {
                "<leader>sda",
                "<cmd>:Stashdown a<CR>",
                mode = { "n" },
                desc = "Archive the current file and all associated images",
            },
            {
                "<leader>sdi",
                "<cmd>:Stashdown ii<CR>",
                mode = { "n" },
                desc =
                "Insert an image into the current note file. Move the image into a folder associated with this note.",
            },
        },
        ft = { "markdown" },
    },
    {
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
    },
})
