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

    "rafamadriz/friendly-snippets",
    require("bbrougher-tech.plugins.luasnip"),
    require("bbrougher-tech.plugins.lsp-zero"),

    require("bbrougher-tech.plugins.auto-save"),
    "numToStr/Comment.nvim",
    require("bbrougher-tech.plugins.cloak"),
    require("bbrougher-tech.plugins.nvim-comment"),
    "fabridamicelli/cronex.nvim",
    require("bbrougher-tech.plugins.gp"),
    -- require("bbrougher-tech.plugins.avante"),
    require("bbrougher-tech.plugins.blade-nav-nvim"),
    "stevearc/dressing.nvim",
    require("bbrougher-tech.plugins.stashdown-nvim"),
    "tpope/vim-fugitive",
    "github/copilot.vim",
    require("bbrougher-tech.plugins.noice"),
    {
        "Decodetalkers/csharpls-extended-lsp.nvim",
        -- ft = { "cs", "csharp" },
    }
})
