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
    "github/copilot.vim",
    "leoluz/nvim-dap-go",
    require("bbrougher-tech.plugins.nvim-dap-ui"),
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
    "FabijanZulj/blame.nvim",
    require("bbrougher-tech.plugins.indent-blankline"),
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
            require("auto-save").setup {
                condition = function(buf)
                    local fn = vim.fn
                    local utils = require("auto-save.utils.data")

                    -- don't save the harpoon menu
                    local bufName = vim.api.nvim_buf_get_name(buf)
                    if string.match(bufName, "__harpoon.menu__") then
                        return false
                    end

                    if
                        fn.getbufvar(buf, "&modifiable") == 1 and
                        utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
                        return true -- met condition(s), can save
                    end
                    return false    -- can't save
                end
            }
        end,
    },
    "numToStr/Comment.nvim",
    require("bbrougher-tech.plugins.nvim-rest"),
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
      "vhyrro/luarocks.nvim",
      priority = 1000,
      config = true,
    },
})
