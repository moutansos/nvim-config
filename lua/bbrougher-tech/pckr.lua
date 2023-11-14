-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not vim.loop.fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require('pckr').add{
    "lewis6991/pckr.nvim";
    {
        "nvim-telescope/telescope.nvim",
        -- tag = "0.1.1",
        -- or                            , branch = '0.1.x',
        requires = { { "nvim-lua/plenary.nvim" } },
    };
    "Mofiqul/vscode.nvim";
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" };
    "nvim-treesitter/nvim-treesitter-context";
    "nvim-treesitter/playground";
    "theprimeagen/harpoon";
    "mbbill/undotree";
    "sbdchd/neoformat";
    "ojroques/vim-oscyank";

    "ryanoasis/vim-devicons";
    "github/copilot.vim";

    "mfussenegger/nvim-dap";
    "leoluz/nvim-dap-go";
    { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } };
    "theHamsta/nvim-dap-virtual-text";
    "nvim-telescope/telescope-dap.nvim";
    "FabijanZulj/blame.nvim";
    {
        "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
        as = "rainbow-delimiters.nvim",
    };
    "lukas-reineke/indent-blankline.nvim";
    {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "Issafalcon/neotest-dotnet",
        },
    };
    "jose-elias-alvarez/null-ls.nvim";
    {
        "iamcco/markdown-preview.nvim",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
    };
    {
        "startup-nvim/startup.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("startup").setup()
        end,
    };
    {
        "nvim-lualine/lualine.nvim",
        requires = { "nvim-tree/nvim-web-devicons", opt = true },
    };
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" }, -- Required
            { -- Optional
                "williamboman/mason.nvim",
                run = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            { "williamboman/mason-lspconfig.nvim" }, -- Optional

            -- Autocompletion
            { "hrsh7th/nvim-cmp" }, -- Required
            { "hrsh7th/cmp-nvim-lsp" }, -- Required
            { "L3MON4D3/LuaSnip" }, -- Required
        },
    };
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup({})
        end,
    };
    -- {
    --     "williamboman/mason.nvim",
    -- };

    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    };
}

